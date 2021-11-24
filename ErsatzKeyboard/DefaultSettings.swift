//
//  DefaultSettings.swift
//  TastyImitationKeyboard
//
//  Created by Alexei Baboulevitch on 11/2/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit

public enum SettingsRow {
    case toggle(_ title: String, setting: String, notes: String?)
    case info(_ title: String, notes: String?)
}

open class DefaultSettings: ExtraView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView?
    @IBOutlet var effectsView: UIVisualEffectView?
    @IBOutlet open var backButton: UIButton?
    @IBOutlet var settingsLabel: UILabel?
    @IBOutlet var pixelLine: UIView?
    
    override var darkMode: Bool {
        didSet {
            self.updateAppearance(darkMode)
        }
    }
    
    let cellBackgroundColorDark = UIColor.white.withAlphaComponent(CGFloat(0.25))
    let cellBackgroundColorLight = UIColor.white.withAlphaComponent(CGFloat(1))
    let cellLabelColorDark = UIColor.white
    let cellLabelColorLight = UIColor.black
    let cellLongLabelColorDark = UIColor.lightGray
    let cellLongLabelColorLight = UIColor.gray
    
    open var settingsTitle: String { "Settings" }
    open var backTitle: String { "Back" }
    
    // TODO: these probably don't belong here, and also need to be localized
    open var settingsList: [(String, [SettingsRow])] {
        get {
            return [
                ("General Settings", [
                    .toggle("Auto-Capitalization", setting: kAutoCapitalization, notes: nil),
                    .toggle("“.” Shortcut", setting: kPeriodShortcut, notes: nil),
                    .toggle("Keyboard Clicks", setting: kKeyboardClicks, notes:
                    "Please note that keyboard clicks will work only if “Allow Full Access” is enabled in the keyboard settings. Unfortunately, this is a limitation of the operating system.")
                ]),
                ("Extra Settings", [
                    .toggle("Allow Lowercase Key Caps", setting: kSmallLowercase, notes:
                    "Changes your key caps to lowercase when Shift is off, making it easier to tell what mode you are in.")
                ])
            ]
        }
    }
    
    required public init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        try! self.loadNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("loading from nib not supported")
    }
    
    func loadNib() throws {
        let mainBundle = Bundle(for: DefaultSettings.self)
        //guard let bundleURL = mainBundle.url(forResource: "TastyKeyboard", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else { throw TastyErrors.unableToLoadPodBundle }
        guard let assets = mainBundle.loadNibNamed("DefaultSettings", owner: self, options: nil) else { throw TastyErrors.unableToLoadNIB }
        assert(assets.count > 0, "Unable to properly load DefaultSettings xib")
        let rootView = assets.first as! UIView
        rootView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rootView)

        let left = NSLayoutConstraint(item: rootView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: rootView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: rootView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: rootView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)

        self.addConstraint(left)
        self.addConstraint(right)
        self.addConstraint(top)
        self.addConstraint(bottom)
        
        self.tableView?.register(DefaultSettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView?.estimatedRowHeight = 44;
        self.tableView?.rowHeight = UITableView.automaticDimension;
        
        // XXX: this is here b/c a totally transparent background does not support scrolling in blank areas
        self.tableView?.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        
        self.updateAppearance(self.darkMode)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingsList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsList[section].1.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.settingsList.count - 1 {
            return 50
        }
        else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingsList[section].0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DefaultSettingsTableViewCell {
            let row = self.settingsList[indexPath.section].1[indexPath.row]
            switch row {
            case .toggle(let text, let key, let notes):
                if cell.sw.allTargets.count == 0 {
                    cell.sw.addTarget(self, action: #selector(DefaultSettings.didTap(_:)), for: UIControl.Event.valueChanged)
                }

                cell.sw.isHidden = false
                cell.sw.isOn = UserDefaults.standard.bool(forKey: key)
                cell.label.text = text
                cell.longLabel.text = notes

                cell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                cell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                cell.longLabel.textColor = (self.darkMode ? cellLongLabelColorDark : cellLongLabelColorLight)
                
                cell.changeConstraints()
            case .info(let title, notes: let notes):
                cell.sw.isHidden = true
                cell.label.text = title
                cell.longLabel.text = notes
                cell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                cell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                cell.longLabel.textColor = (self.darkMode ? cellLongLabelColorDark : cellLongLabelColorLight)
                cell.changeConstraints()
            }
            return cell
        }
        else {
            assert(false, "this is a bad thing that just happened")
            return UITableViewCell()
        }
    }
    
    func updateAppearance(_ dark: Bool) {
        settingsLabel?.text = settingsTitle
        backButton?.setTitle("〈 " + backTitle, for: .normal)
        
        if dark {
            let _ = self.effectsView?.effect //AB: used for side effect, maybe? can't remember, probably junk
            let blueColor = UIColor(red: 135/CGFloat(255), green: 206/CGFloat(255), blue: 250/CGFloat(255), alpha: 1)
            self.pixelLine?.backgroundColor = blueColor.withAlphaComponent(CGFloat(0.5))
            self.backButton?.setTitleColor(blueColor, for: .normal)
            self.settingsLabel?.textColor = UIColor.white
            
            if let visibleCells = self.tableView?.visibleCells {
                for cell in visibleCells {
                    cell.backgroundColor = cellBackgroundColorDark
                    let label = cell.viewWithTag(2) as? UILabel
                    label?.textColor = cellLabelColorDark
                    let longLabel = cell.viewWithTag(3) as? UITextView
                    longLabel?.textColor = cellLongLabelColorDark
                }
            }
        }
        else {
            let blueColor = UIColor(red: 0/CGFloat(255), green: 122/CGFloat(255), blue: 255/CGFloat(255), alpha: 1)
            self.pixelLine?.backgroundColor = blueColor.withAlphaComponent(CGFloat(0.5))
            self.backButton?.setTitleColor(blueColor, for: .normal)
            self.settingsLabel?.textColor = UIColor.gray
            
            if let visibleCells = self.tableView?.visibleCells {
                for cell in visibleCells {
                    cell.backgroundColor = cellBackgroundColorLight
                    let label = cell.viewWithTag(2) as? UILabel
                    label?.textColor = cellLabelColorLight
                    let longLabel = cell.viewWithTag(3) as? UITextView
                    longLabel?.textColor = cellLongLabelColorLight
                }
            }
        }
    }
    
    @objc func didTap(_ sender: UISwitch) {
        // TODO(robin): Find a better way to get the appropriate option
        if let cell = sender.superview?.superview as? UITableViewCell {
            if let indexPath = self.tableView?.indexPath(for: cell) {
                let row = self.settingsList[indexPath.section].1[indexPath.row]
                switch row {
                case .toggle(_, setting: let key, notes: _):
                    UserDefaults.standard.set(sender.isOn, forKey: key)
                case .info(_, _): break
                }
            }
        }
    }
}

class DefaultSettingsTableViewCell: UITableViewCell {
    
    var sw: UISwitch
    var label: UILabel
    var longLabel: UITextView
    var constraintsSetForLongLabel: Bool
    var cellConstraints: [NSLayoutConstraint]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.sw = UISwitch()
        self.label = UILabel()
        self.longLabel = UITextView()
        self.cellConstraints = []
        
        self.constraintsSetForLongLabel = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.sw.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.longLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.longLabel.text = nil
        self.longLabel.isScrollEnabled = false
        self.longLabel.isSelectable = false
        self.longLabel.backgroundColor = UIColor.clear
        
        self.sw.tag = 1
        self.label.tag = 2
        self.longLabel.tag = 3

        self.contentView.addSubview(self.sw)
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.longLabel)
        
        self.addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        let margin: CGFloat = 8
        let sideMargin = margin * 2
        
        let hasLongText = self.longLabel.text != nil && !self.longLabel.text.isEmpty
        if hasLongText {
            let switchSide = NSLayoutConstraint(item: sw, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -sideMargin)
            let switchTop = NSLayoutConstraint(item: sw, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: margin)
            let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: sideMargin)
            let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sw, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            
            self.addConstraint(switchSide)
            self.addConstraint(switchTop)
            self.addConstraint(labelSide)
            self.addConstraint(labelCenter)
            
            let left = NSLayoutConstraint(item: longLabel, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: sideMargin)
            let right = NSLayoutConstraint(item: longLabel, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -sideMargin)
            let top = NSLayoutConstraint(item: longLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sw, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: margin)
            let bottom = NSLayoutConstraint(item: longLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -margin)
            
            self.addConstraint(left)
            self.addConstraint(right)
            self.addConstraint(top)
            self.addConstraint(bottom)
        
            self.cellConstraints += [switchSide, switchTop, labelSide, labelCenter, left, right, top, bottom]
            
            self.constraintsSetForLongLabel = true
        }
        else {
            let switchSide = NSLayoutConstraint(item: sw, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -sideMargin)
            let switchTop = NSLayoutConstraint(item: sw, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: margin)
            let switchBottom = NSLayoutConstraint(item: sw, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -margin)
            let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: sideMargin)
            let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: sw, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            
            self.addConstraint(switchSide)
            self.addConstraint(switchTop)
            self.addConstraint(switchBottom)
            self.addConstraint(labelSide)
            self.addConstraint(labelCenter)
            
            self.cellConstraints += [switchSide, switchTop, switchBottom, labelSide, labelCenter]
            
            self.constraintsSetForLongLabel = false
        }
    }
    
    // XXX: not in updateConstraints because it doesn't play nice with UITableViewAutomaticDimension for some reason
    func changeConstraints() {
        let hasLongText = self.longLabel.text != nil && !self.longLabel.text.isEmpty
        if hasLongText != self.constraintsSetForLongLabel {
            self.removeConstraints(self.cellConstraints)
            self.cellConstraints.removeAll()
            self.addConstraints()
        }
    }
}
