//
//  ErsatzKeyboardViewController.swift
//  Keyboard
//
//  Created by Alexei Baboulevitch on 6/9/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit
import AudioToolbox

open class ErsatzKeyboardViewController: UIInputViewController {
    /// The keyboard to display
    public var keyboard: Keyboard!

    /// The settings configuration to use for this keyboard
    public var settingsConfig: SettingsConfiguration! = SettingsConfiguration.defaultSettings
    
    /// The provider that handles actual settings values
    public let settingsProvider: SettingsProvider = UserDefaultsSettingsProvider()

    let backspaceDelay: TimeInterval = 0.5
    let backspaceRepeat: TimeInterval = 0.07
    var forwardingView: ForwardingView!
    var layout: KeyboardLayout?
    var heightConstraint: NSLayoutConstraint?
    
    var bannerView: ExtraView?
    
    /// View controller for displaying the settings panel
    private lazy var settingsVC: SettingsViewController = {
        let settingsVC = SettingsViewController(
            settingsList: settingsConfig,
            settingsProvider: settingsProvider,
            backTapped: { [weak self] in self?.toggleSettings() })
        settingsVC.view.isHidden = true
        return settingsVC
    }()
    
    /// The settings key. Used for setting voiceover focus when closing settings. May not work if there is more than one settings key.
    private var settingsKey: KeyboardKey?

    // MARK: - Metrics

    open private(set) var topBannerHeight: CGFloat = 30.0
    
    public var currentMode: Int {
        didSet {
            if oldValue != currentMode {
                setMode(currentMode)
            }
        }
    }
    
    var backspaceActive: Bool {
        get {
            return (backspaceDelayTimer != nil) || (backspaceRepeatTimer != nil)
        }
    }
    var backspaceDelayTimer: Timer?
    public var backspaceRepeatTimer: Timer?
    
    public enum AutoPeriodState {
        case noSpace
        case firstSpace
    }
    
    public var autoPeriodState: AutoPeriodState = .noSpace
    var lastCharCountInBeforeContext: Int = 0
    
    public var shiftState: ShiftState {
        didSet {
            switch shiftState {
            case .disabled:
                self.updateKeyCaps(false)
            case .enabled:
                self.updateKeyCaps(true)
            case .locked:
                self.updateKeyCaps(true)
            }
        }
    }
    
    // state tracking during shift tap
    var shiftWasMultitapped: Bool = false
    var shiftStartingState: ShiftState?
    
    public var keyboardHeight: CGFloat {
        get {
            if let constraint = self.heightConstraint {
                return constraint.constant
            }
            else {
                return 0
            }
        }
        set {
            self.setHeight(newValue)
        }
    }
    
    // TODO: why does the app crash if this isn't here?
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.shiftState = .disabled
        self.currentMode = 0
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        settingsProvider.setDefaults(from: settingsConfig)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ErsatzKeyboardViewController.defaultsChanged(_:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    deinit {
        backspaceDelayTimer?.invalidate()
        backspaceRepeatTimer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func defaultsChanged(_ notification: Notification) {
        //let defaults = notification.object as? NSUserDefaults
        self.updateKeyCaps(self.shiftState.isUppercase)
    }
    
    // without this here kludge, the height constraint for the keyboard does not work for some reason
    var kludge: UIView?
    func setupKludge() {
        if self.kludge == nil {
            let kludge = UIView()
            self.view.addSubview(kludge)
            kludge.translatesAutoresizingMaskIntoConstraints = false
            kludge.isHidden = true
            
            let a = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
            let b = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
            let c = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            let d = NSLayoutConstraint(item: kludge, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            self.view.addConstraints([a, b, c, d])
            
            self.kludge = kludge
        }
    }
    
    /*
    BUG NOTE

    For some strange reason, a layout pass of the entire keyboard is triggered 
    whenever a popup shows up, if one of the following is done:

    a) The forwarding view uses an autoresizing mask.
    b) The forwarding view has constraints set anywhere other than init.

    On the other hand, setting (non-autoresizing) constraints or just setting the
    frame in layoutSubviews works perfectly fine.

    I don't really know what to make of this. Am I doing Autolayout wrong, is it
    a bug, or is it expected behavior? Perhaps this has to do with the fact that
    the view's frame is only ever explicitly modified when set directly in layoutSubviews,
    and not implicitly modified by various Autolayout constraints
    (even though it should really not be changing).
    */
    
    var constraintsAdded: Bool = false
    func setupLayout() {
        if !constraintsAdded {
            self.layout = Self.layoutClass.init(
                model: self.keyboard,
                superview: self.forwardingView,
                layoutConstants: Self.layoutConstants,
                globalColors: Self.globalColors,
                darkMode: self.darkMode(),
                solidColorMode: self.solidColorMode()
            )
            
            self.layout?.initialize()
            self.setMode(0)
            
            self.setupKludge()
            
            self.updateKeyCaps(self.shiftState.isUppercase)
            self.updateCapsIfNeeded()
            
            self.updateAppearances(self.darkMode())
            self.addInputTraitsObservers()
            
            self.constraintsAdded = true
        }
    }
    
    // only available after frame becomes non-zero
    func darkMode() -> Bool {
        let darkMode = { () -> Bool in
            let proxy = self.textDocumentProxy
            return proxy.keyboardAppearance == UIKeyboardAppearance.dark
        }()
        
        return darkMode
    }
    
    public func solidColorMode() -> Bool {
        return UIAccessibility.isReduceTransparencyEnabled
    }
    
    public func isPortrait() -> Bool
    {
        let size = UIScreen.main.bounds.size
        if size.width > size.height {
            //print("Landscape: \(size.width) X \(size.height)")
            return false
        } else {
            //print("Portrait: \(size.width) X \(size.height)")
            return true
        }
    }
    
    var lastLayoutBounds: CGRect?
    override open func viewDidLayoutSubviews() {
        if view.bounds == CGRect.zero {
            return
        }
        
        self.setupLayout()
        
        let orientationSavvyBounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.height(orientationIsPortrait: self.isPortrait(), withTopBanner: false))
        
        if (lastLayoutBounds != nil && lastLayoutBounds == orientationSavvyBounds) {
            // do nothing
        }
        else {
            let uppercase = self.shiftState.isUppercase
            let characterUppercase = (settingsProvider.value(for: SettingsKey.smallLowercase) ? uppercase : true)
            
            self.forwardingView.frame = orientationSavvyBounds
            self.layout?.layoutKeys(self.currentMode, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
            self.lastLayoutBounds = orientationSavvyBounds
            self.setupKeys()
        }
        
        self.bannerView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: topBannerHeight)
        
        let newOrigin = CGPoint(x: 0, y: self.view.bounds.height - self.forwardingView.bounds.height)
        self.forwardingView.frame.origin = newOrigin
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        forwardingView = ForwardingView(frame: CGRect.zero)
        forwardingView.backgroundColor = GlobalColors.keyboardBackgroundColor
        view.addSubview(forwardingView)
        
        if let banner = createBanner() {
            banner.isHidden = true
            view.insertSubview(banner, belowSubview: self.forwardingView)
            bannerView = banner
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        bannerView?.isHidden = false
        keyboardHeight = height(orientationIsPortrait: isPortrait(), withTopBanner: true)
        forwardingView.backgroundColor = GlobalColors.keyboardBackgroundColor
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
    
    override open func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.forwardingView.resetTrackedViews()
        self.shiftStartingState = nil
        self.shiftWasMultitapped = false
        
        // optimization: ensures smooth animation
        if let keyPool = self.layout?.keyPool {
            for view in keyPool {
                view.shouldRasterize = true
            }
        }
        
        self.keyboardHeight = self.height(orientationIsPortrait: self.isPortrait(), withTopBanner: true)
    }
    
    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // optimization: ensures quick mode and shift transitions
        if let keyPool = self.layout?.keyPool {
            for view in keyPool {
                view.shouldRasterize = false
            }
        }
    }
    
    public func height(orientationIsPortrait isPortrait: Bool, withTopBanner: Bool) -> CGFloat {
        let isPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        
        // AB: consider re-enabling this when interfaceOrientation actually breaks
        //// HACK: Detecting orientation manually
        //let screenSize: CGSize = UIScreen.main.bounds.size
        //let orientation: UIInterfaceOrientation = screenSize.width < screenSize.height ? .portrait : .landscapeLeft
        
        //TODO: hardcoded stuff
        let actualScreenWidth = (UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale)
        let canonicalPortraitHeight: CGFloat
        let canonicalLandscapeHeight: CGFloat
        if isPad {
            canonicalPortraitHeight = 264
            canonicalLandscapeHeight = 352
        }
        else {
            canonicalPortraitHeight = isPortrait && actualScreenWidth >= 400 ? 226 : 216
            canonicalLandscapeHeight = 162
        }
        
        let topBannerHeight = (withTopBanner ? topBannerHeight : 0)
        
        return CGFloat(isPortrait ? canonicalPortraitHeight + topBannerHeight : canonicalLandscapeHeight + topBannerHeight)
    }
    
    /*
    BUG NOTE

    None of the UIContentContainer methods are called for this controller.
    */
    
    //override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    //    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    //}
    
    open func setupKeys() {
        if self.layout == nil {
            return
        }
        
        for page in keyboard.pages {
            for rowKeys in page.rows { // TODO: quick hack
                for key in rowKeys {
                    if let keyView = self.layout?.viewForKey(key) {
                        keyView.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
                        
                        switch key.type {
                        case Key.KeyType.keyboardChange:
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.advanceTapped(_:)),
                                              for: .touchUpInside)
                        case Key.KeyType.backspace:
                            let cancelEvents: UIControl.Event = [UIControl.Event.touchUpInside, UIControl.Event.touchUpInside, UIControl.Event.touchDragExit, UIControl.Event.touchUpOutside, UIControl.Event.touchCancel, UIControl.Event.touchDragOutside]
                            
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.backspaceDown(_:)),
                                              for: .touchDown)
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.backspaceUp(_:)),
                                              for: cancelEvents)
                        case Key.KeyType.shift:
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.shiftDown(_:)),
                                              for: .touchDown)
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.shiftUp(_:)),
                                              for: .touchUpInside)
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.shiftDoubleTapped(_:)),
                                              for: .touchDownRepeat)
                        case Key.KeyType.modeChange:
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.modeChangeTapped(_:)),
                                              for: .touchDown)
                        case Key.KeyType.settings:
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.toggleSettings),
                                              for: .touchUpInside)
                            settingsKey = keyView
                        default:
                            break
                        }
                        
                        if key.isCharacter {
                            if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
                                keyView.addTarget(self,
                                                  action: #selector(ErsatzKeyboardViewController.showPopup(_:)),
                                                  for: [.touchDown, .touchDragInside, .touchDragEnter])
                                keyView.addTarget(keyView,
                                                  action: #selector(KeyboardKey.hidePopup),
                                                  for: [.touchDragExit, .touchCancel])
                                keyView.addTarget(self,
                                                  action: #selector(ErsatzKeyboardViewController.hidePopupDelay(_:)),
                                                  for: [.touchUpInside, .touchUpOutside, .touchDragOutside])
                            }
                        }
                        
                        if key.hasOutput {
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.keyPressedHelper(_:)),
                                              for: .touchUpInside)
                        }
                        
                        if key.type != Key.KeyType.shift && key.type != Key.KeyType.modeChange {
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.highlightKey(_:)),
                                              for: [.touchDown, .touchDragInside, .touchDragEnter])
                            keyView.addTarget(self,
                                              action: #selector(ErsatzKeyboardViewController.unHighlightKey(_:)),
                                              for: [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit, .touchCancel])
                        }
                        
                        keyView.addTarget(self,
                                          action: #selector(ErsatzKeyboardViewController.playKeySound),
                                          for: .touchDown)
                    }
                }
            }
        }
    }
    
    /////////////////
    // POPUP DELAY //
    /////////////////
    
    var keyWithDelayedPopup: KeyboardKey?
    var popupDelayTimer: Timer?
    
    @objc func showPopup(_ sender: KeyboardKey) {
        if sender == self.keyWithDelayedPopup {
            self.popupDelayTimer?.invalidate()
        }
        sender.showPopup()
    }
    
    @objc func hidePopupDelay(_ sender: KeyboardKey) {
        self.popupDelayTimer?.invalidate()
        
        if sender != self.keyWithDelayedPopup {
            self.keyWithDelayedPopup?.hidePopup()
            self.keyWithDelayedPopup = sender
        }
        
        if sender.popup != nil {
            self.popupDelayTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ErsatzKeyboardViewController.hidePopupCallback), userInfo: nil, repeats: false)
        }
    }
    
    @objc func hidePopupCallback() {
        self.keyWithDelayedPopup?.hidePopup()
        self.keyWithDelayedPopup = nil
        self.popupDelayTimer = nil
    }
    
    /////////////////////
    // POPUP DELAY END //
    /////////////////////
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    // TODO: this is currently not working as intended; only called when selection changed -- iOS bug
    override open func textDidChange(_ textInput: UITextInput?) {
        self.contextChanged()
    }
    
    func contextChanged() {
        self.updateCapsIfNeeded()
        self.autoPeriodState = .noSpace
    }
    
    func setHeight(_ height: CGFloat) {
        if self.heightConstraint == nil {
            self.heightConstraint = NSLayoutConstraint(
                item:self.view!,
                attribute:NSLayoutConstraint.Attribute.height,
                relatedBy:NSLayoutConstraint.Relation.equal,
                toItem:nil,
                attribute:NSLayoutConstraint.Attribute.notAnAttribute,
                multiplier:0,
                constant:height)
            self.heightConstraint!.priority = UILayoutPriority(rawValue: 1000)
            
            self.view.addConstraint(self.heightConstraint!) // TODO: what if view already has constraint added?
        }
        else {
            self.heightConstraint?.constant = height
        }
    }
    
    func updateAppearances(_ appearanceIsDark: Bool) {
        self.layout?.solidColorMode = self.solidColorMode()
        self.layout?.darkMode = appearanceIsDark
        self.layout?.updateKeyAppearance()
        
        self.bannerView?.darkMode = appearanceIsDark
    }
    
    @objc func highlightKey(_ sender: KeyboardKey) {
        sender.isHighlighted = true
    }
    
    @objc func unHighlightKey(_ sender: KeyboardKey) {
        sender.isHighlighted = false
    }
    
    @objc func keyPressedHelper(_ sender: KeyboardKey) {
        if let model = self.layout?.keyForView(sender) {
            self.keyPressed(model)

            // auto exit from special char subkeyboard
            if model.type == Key.KeyType.space || model.type == Key.KeyType.return {
                self.currentMode = 0
            }
            else if model.lowercaseOutput == "'" {
                self.currentMode = 0
            }
            else if model.type == Key.KeyType.character {
                self.currentMode = 0
            }
            
            // auto period on double space
            // TODO: timeout
            
            self.handleAutoPeriod(model)
            // TODO: reset context
        }
        
        self.updateCapsIfNeeded()
    }
    
    func handleAutoPeriod(_ key: Key) {
        if !settingsProvider.value(for: SettingsKey.periodShortcut) {
            return
        }
        
        if self.autoPeriodState == .firstSpace {
            if key.type != Key.KeyType.space {
                self.autoPeriodState = .noSpace
                return
            }
            
            let charactersAreInCorrectState = { () -> Bool in
                let previousContext = self.textDocumentProxy.documentContextBeforeInput
                
                if previousContext == nil || (previousContext!).count < 3 {
                    return false
                }
                
                var index = previousContext!.endIndex
                
                index = previousContext!.index(before: index)
                if previousContext![index] != " " {
                    return false
                }
                
                index = previousContext!.index(before: index)
                if previousContext![index] != " " {
                    return false
                }
                
                index = previousContext!.index(before: index)
                let char = previousContext![index]
                if self.characterIsWhitespace(char) || self.characterIsPunctuation(char) || char == "," {
                    return false
                }
                
                return true
            }()
            
            if charactersAreInCorrectState {
                self.textDocumentProxy.deleteBackward()
                self.textDocumentProxy.deleteBackward()
                self.textDocumentProxy.insertText(".")
                self.textDocumentProxy.insertText(" ")
            }
            
            self.autoPeriodState = .noSpace
        }
        else {
            if key.type == Key.KeyType.space {
                self.autoPeriodState = .firstSpace
            }
        }
    }
    
    func cancelBackspaceTimers() {
        self.backspaceDelayTimer?.invalidate()
        self.backspaceRepeatTimer?.invalidate()
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = nil
    }
    
    @objc open func backspaceDown(_ sender: KeyboardKey) {
        self.cancelBackspaceTimers()
        
        self.textDocumentProxy.deleteBackward()
        self.updateCapsIfNeeded()
        
        // trigger for subsequent deletes
        self.backspaceDelayTimer = Timer.scheduledTimer(timeInterval: backspaceDelay - backspaceRepeat, target: self, selector: #selector(ErsatzKeyboardViewController.backspaceDelayCallback), userInfo: nil, repeats: false)
    }
    
    @objc open func backspaceUp(_ sender: KeyboardKey) {
        self.cancelBackspaceTimers()
    }
    
    @objc func backspaceDelayCallback() {
        self.backspaceDelayTimer = nil
        self.backspaceRepeatTimer = Timer.scheduledTimer(timeInterval: backspaceRepeat, target: self, selector: #selector(ErsatzKeyboardViewController.backspaceRepeatCallback), userInfo: nil, repeats: true)
    }
    
    @objc func backspaceRepeatCallback() {
        self.playKeySound()
        
        self.textDocumentProxy.deleteBackward()
        self.updateCapsIfNeeded()
    }
    
    @objc func shiftDown(_ sender: KeyboardKey) {
        self.shiftStartingState = self.shiftState
        
        if let shiftStartingState = self.shiftStartingState {
            if shiftStartingState.isUppercase {
                // handled by shiftUp
                return
            }
            else {
                switch self.shiftState {
                case .disabled:
                    self.shiftState = .enabled
                case .enabled:
                    self.shiftState = .disabled
                case .locked:
                    self.shiftState = .disabled
                }
                
                (sender.shape as? ShiftShape)?.withLock = false
            }
        }
    }
    
    @objc func shiftUp(_ sender: KeyboardKey) {
        if self.shiftWasMultitapped {
            // do nothing
        }
        else {
            if let shiftStartingState = self.shiftStartingState {
                if !shiftStartingState.isUppercase {
                    // handled by shiftDown
                }
                else {
                    switch self.shiftState {
                    case .disabled:
                        self.shiftState = .enabled
                    case .enabled:
                        self.shiftState = .disabled
                    case .locked:
                        self.shiftState = .disabled
                    }
                    
                    (sender.shape as? ShiftShape)?.withLock = false
                }
            }
        }

        self.shiftStartingState = nil
        self.shiftWasMultitapped = false
    }
    
    @objc func shiftDoubleTapped(_ sender: KeyboardKey) {
        self.shiftWasMultitapped = true
        
        switch self.shiftState {
        case .disabled:
            self.shiftState = .locked
        case .enabled:
            self.shiftState = .locked
        case .locked:
            self.shiftState = .disabled
        }
    }
    
    open func updateKeyCaps(_ uppercase: Bool) {
        let characterUppercase = (settingsProvider.value(for: SettingsKey.smallLowercase) ? uppercase : true)
        self.layout?.updateKeyCaps(false, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
    }
    
    @objc func modeChangeTapped(_ sender: KeyboardKey) {
        if let toMode = self.layout?.viewToModel[sender]?.toMode {
            self.currentMode = toMode
        }
    }
    
    func setMode(_ mode: Int) {
        self.forwardingView.resetTrackedViews()
        self.shiftStartingState = nil
        self.shiftWasMultitapped = false
        
        let uppercase = self.shiftState.isUppercase
        let characterUppercase = (settingsProvider.value(for: SettingsKey.smallLowercase) ? uppercase : true)
        self.layout?.layoutKeys(mode, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
        
        self.setupKeys()
    }
    
    @objc func advanceTapped(_ sender: KeyboardKey) {
        self.forwardingView.resetTrackedViews()
        self.shiftStartingState = nil
        self.shiftWasMultitapped = false
        
        self.advanceToNextInputMode()
    }
    
    @IBAction open func toggleSettings() {
        if settingsVC.parent == nil {
            addChild(settingsVC)
            view.addEdgeMatchedSubview(settingsVC.view)
        }
        
        let showSettings = settingsVC.view.isHidden
        
        settingsVC.view.isHidden = !showSettings
        self.forwardingView.isHidden = showSettings
        self.forwardingView.isUserInteractionEnabled = !showSettings
        self.bannerView?.isHidden = showSettings
        
        if showSettings {
            settingsVC.setVoiceoverFocus()
        } else {
            UIAccessibility.post(notification: .screenChanged, argument: settingsKey)
        }
    }
    
    public func updateCapsIfNeeded() {
        if self.shouldAutoCapitalize() {
            switch self.shiftState {
            case .disabled:
                self.shiftState = .enabled
            case .enabled:
                self.shiftState = .enabled
            case .locked:
                self.shiftState = .locked
            }
        }
        else {
            switch self.shiftState {
            case .disabled:
                self.shiftState = .disabled
            case .enabled:
                self.shiftState = .disabled
            case .locked:
                self.shiftState = .locked
            }
        }
    }
    
    func characterIsPunctuation(_ character: Character) -> Bool {
        return (character == ".") || (character == "!") || (character == "?")
    }
    
    func characterIsNewline(_ character: Character) -> Bool {
        return (character == "\n") || (character == "\r")
    }
    
    func characterIsWhitespace(_ character: Character) -> Bool {
        // there are others, but who cares
        return (character == " ") || (character == "\n") || (character == "\r") || (character == "\t")
    }
    
    func stringIsWhitespace(_ string: String?) -> Bool {
        if string != nil {
            for char in (string!) {
                if !characterIsWhitespace(char) {
                    return false
                }
            }
        }
        return true
    }
    
    func shouldAutoCapitalize() -> Bool {
        if !settingsProvider.value(for: SettingsKey.autoCapitalization) {
            return false
        }
        
        let traits = self.textDocumentProxy
        if let autocapitalization = traits.autocapitalizationType {
            let documentProxy = self.textDocumentProxy
            //var beforeContext = documentProxy.documentContextBeforeInput
            
            switch autocapitalization {
            case .none:
                return false
            case .words:
                if let beforeContext = documentProxy.documentContextBeforeInput {
                    let previousCharacter = beforeContext[beforeContext.index(before: beforeContext.endIndex)]
                    return self.characterIsWhitespace(previousCharacter)
                }
                else {
                    return true
                }
            
            case .sentences:
                if let beforeContext = documentProxy.documentContextBeforeInput {
                    let offset = min(3, beforeContext.count)
                    var index = beforeContext.endIndex
                    
                    for i in 0 ..< offset {
                        index = beforeContext.index(before: index)
                        let char = beforeContext[index]
                        
                        if characterIsPunctuation(char) {
                            if i == 0 {
                                return false //not enough spaces after punctuation
                            }
                            else {
                                return true //punctuation with at least one space after it
                            }
                        }
                        else {
                            if !characterIsWhitespace(char) {
                                return false //hit a foreign character before getting to 3 spaces
                            }
                            else if characterIsNewline(char) {
                                return true //hit start of line
                            }
                        }
                    }
                    
                    return true //either got 3 spaces or hit start of line
                }
                else {
                    return true
                }
            case .allCharacters:
                return true
            @unknown default:
                return false
            }
        }
        else {
            return false
        }
    }
    
    // this only works if full access is enabled
    @objc public func playKeySound() {
        if !settingsProvider.value(for: SettingsKey.keyboardClicks) {
            return
        }
        
        DispatchQueue.global(qos: .default).async(execute: {
            AudioServicesPlaySystemSound(1104)
        })
    }
    
    //////////////////////////////////////
    // MOST COMMONLY EXTENDABLE METHODS //
    //////////////////////////////////////
    
    open class var layoutClass: KeyboardLayout.Type { get { return KeyboardLayout.self }}
    open class var layoutConstants: LayoutConstants.Type { get { return LayoutConstants.self }}
    open class var globalColors: GlobalColors.Type { get { return GlobalColors.self }}
    
    open func keyPressed(_ key: Key) {
        self.textDocumentProxy.insertText(key.outputForCase(self.shiftState.isUppercase))
    }
    
    // a banner that sits in the empty space on top of the keyboard
    open func createBanner() -> ExtraView? {
        // note that dark mode is not yet valid here, so we just put false for clarity
        //return ExtraView(globalColors: self.dynamicType.globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        return nil
    }
}
