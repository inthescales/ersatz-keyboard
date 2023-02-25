//
//  KeyboardKey.swift
//  TransliteratingKeyboard
//
//  Created by Alexei Baboulevitch on 6/9/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit

/// Delegate protocol for KeyboardKey.
/// Popup constraints have to be setup with the topmost view in mind; hence these callbacks
protocol KeyboardKeyDelegate: AnyObject {
    func popupFrame(for key: KeyboardKey, direction: Direction) -> CGRect
    func willShowPopup(for key: KeyboardKey, direction: Direction) //may be called multiple times during layout
    func willHidePopup(for key: KeyboardKey)
}

/// Control for drawing a key on the keyboard, and presenting its popup
public class KeyboardKey: UIControl {
    
    weak var delegate: KeyboardKeyDelegate?
    
    var text: String = "" {
        didSet {
            label.text = text
            label.frame = CGRect(
                x: labelInset,
                y: labelInset,
                width: bounds.width - labelInset * 2,
                height: bounds.height - labelInset * 2
            )
        }
    }
    
    public var color: UIColor { didSet { updateColors() }}
    var underColor: UIColor { didSet { updateColors() }}
    var borderColor: UIColor { didSet { updateColors() }}
    var popupColor: UIColor { didSet { updateColors() }}
    var drawUnder: Bool { didSet { updateColors() }}
    var drawOver: Bool { didSet { updateColors() }}
    var drawBorder: Bool { didSet { updateColors() }}
    var underOffset: CGFloat { didSet { updateColors() }}
    
    public var textColor: UIColor { didSet { updateColors() }}
    public var downColor: UIColor? { didSet { updateColors() }}
    var downUnderColor: UIColor? { didSet { updateColors() }}
    var downBorderColor: UIColor? { didSet { updateColors() }}
    public var downTextColor: UIColor? { didSet { updateColors() }}
    
    var labelInset: CGFloat = 0 {
        didSet {
            if oldValue != labelInset {
                self.label.frame = CGRect(x: self.labelInset, y: self.labelInset, width: self.bounds.width - self.labelInset * 2, height: self.bounds.height - self.labelInset * 2)
            }
        }
    }
    
    var shouldRasterize: Bool = false {
        didSet {
            for view in [self.displayView, self.borderView, self.underView] {
                view.layer.shouldRasterize = shouldRasterize
                view.layer.rasterizationScale = UIScreen.main.scale
            }
        }
    }
    
    /// The direction that popups should appear from this key
    private let popupDirection: Direction = .up
    
    override open var isEnabled: Bool { didSet { updateColors() }}
    override open var isSelected: Bool {
        didSet {
            updateColors()
        }
    }
    override open var isHighlighted: Bool {
        didSet {
            updateColors()
        }
    }
    
    /// Label displaying a character keycaps, if there is one
    lazy var label: UILabel = {
        // TODO(robin): See if we can make it so this only gets initialized if it's
        // not a shape key. Also see if we can make it private.
        
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.baselineAdjustment = UIBaselineAdjustment.alignCenters
        label.font = label.font.withSize(22)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = CGFloat(0.1)
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        return label
    }()

    /// Label displaying the key's assigned character in the popup when tapped
    var popupLabel: UILabel?
    
    /// Shape for drawing non-character keycaps
    var shape: Shape? {
        didSet {
            if oldValue != nil && shape == nil {
                oldValue?.removeFromSuperview()
            }
            self.redrawShape()
            updateColors()
        }
    }
    
    var background: KeyboardKeyBackground
    var popup: KeyboardKeyBackground?
    var connector: KeyboardConnector?
    
    var displayView = ShapeView()
    var borderView = ShapeView()
    var underView = ShapeView()
    
    var shadowView = UIView()
    var shadowLayer = CAShapeLayer()
    
    init() {
        color = UIColor.white
        underColor = UIColor.gray
        borderColor = UIColor.black
        popupColor = UIColor.white
        drawUnder = true
        drawOver = true
        drawBorder = false
        underOffset = 1
        
        background = KeyboardKeyBackground(cornerRadius: 4, underOffset: underOffset)
        
        textColor = UIColor.black
        
        super.init(frame: CGRect.zero)
        
        addSubview(shadowView)
        shadowView.layer.addSublayer(shadowLayer)
        
        addSubview(displayView)
        addSubview(underView)
        addSubview(borderView)
        
        addSubview(background)
        background.addSubview(label)
        
        displayView.isOpaque = false
        underView.isOpaque = false
        borderView.isOpaque = false
        
        shadowLayer.shadowOpacity = Float(0.2)
        shadowLayer.shadowRadius = 4
        shadowLayer.shadowOffset = CGSize(width: 0, height: 3)
        
        borderView.lineWidth = CGFloat(0.5)
        borderView.fillColor = UIColor.clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    var oldBounds: CGRect?
    override open func layoutSubviews() {
        self.layoutPopupIfNeeded()
        
        let boundingBox = (self.popup != nil ? self.bounds.union(self.popup!.frame) : self.bounds)
        
        if self.bounds.width == 0 || self.bounds.height == 0 {
            return
        }
        if oldBounds != nil && boundingBox.size.equalTo(oldBounds!.size) {
            return
        }
        oldBounds = boundingBox

        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.background.frame = self.bounds
        self.label.frame = CGRect(x: self.labelInset, y: self.labelInset, width: self.bounds.width - self.labelInset * 2, height: self.bounds.height - self.labelInset * 2)
        
        self.displayView.frame = boundingBox
        self.shadowView.frame = boundingBox
        self.borderView.frame = boundingBox
        self.underView.frame = boundingBox
        
        CATransaction.commit()
        
        self.refreshViews()
    }
    
    func refreshViews() {
        self.refreshShapes()
        self.redrawShape()
        self.updateColors()
    }
    
    func refreshShapes() {
        // TODO: dunno why this is necessary
        self.background.setNeedsLayout()
        
        self.background.layoutIfNeeded()
        self.popup?.layoutIfNeeded()
        self.connector?.layoutIfNeeded()
        
        let testPath = UIBezierPath()
        let edgePath = UIBezierPath()
        
        let unitSquare = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        // TODO: withUnder
        let addCurves = { (fromShape: KeyboardKeyBackground?, toPath: UIBezierPath, toEdgePaths: UIBezierPath) -> Void in
            if let shape = fromShape {
                let path = shape.fillPath
                let translatedUnitSquare = self.displayView.convert(unitSquare, from: shape)
                let transformFromShapeToView = CGAffineTransform(translationX: translatedUnitSquare.origin.x, y: translatedUnitSquare.origin.y)
                path?.apply(transformFromShapeToView)
                if path != nil { toPath.append(path!) }
                if let edgePaths = shape.edgePaths {
                    for (_, anEdgePath) in edgePaths.enumerated() {
                        let editablePath = anEdgePath
                        editablePath.apply(transformFromShapeToView)
                        toEdgePaths.append(editablePath)
                    }
                }
            }
        }
        
        addCurves(self.popup, testPath, edgePath)
        addCurves(self.connector, testPath, edgePath)
        
        let shadowPath = UIBezierPath(cgPath: testPath.cgPath)
        
        addCurves(self.background, testPath, edgePath)
        
        let underPath = self.background.underPath
        let translatedUnitSquare = self.displayView.convert(unitSquare, from: self.background)
        let transformFromShapeToView = CGAffineTransform(translationX: translatedUnitSquare.origin.x, y: translatedUnitSquare.origin.y)
        underPath?.apply(transformFromShapeToView)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if popup != nil {
            self.shadowLayer.shadowPath = shadowPath.cgPath
        }
        
        self.underView.curve = underPath
        self.displayView.curve = testPath
        self.borderView.curve = edgePath
        
        if let borderLayer = self.borderView.layer as? CAShapeLayer {
            borderLayer.strokeColor = UIColor.green.cgColor
        }
        
        CATransaction.commit()
    }
    
    func layoutPopupIfNeeded() {
        if self.popup != nil {
            self.shadowView.isHidden = false
            self.borderView.isHidden = false
            
            self.layoutPopup(popupDirection)
            self.configurePopup(popupDirection)
            
            self.delegate?.willShowPopup(for: self, direction: popupDirection)
        }
        else {
            self.shadowView.isHidden = true
            self.borderView.isHidden = true
        }
    }
    
    func redrawShape() {
        guard let shape = self.shape else {
            return
        }
        
        self.text = ""
        shape.removeFromSuperview()
        self.addSubview(shape)
        
        let pointOffset: CGFloat = 4
        let size = CGSize(width: self.bounds.width - pointOffset - pointOffset, height: self.bounds.height - pointOffset - pointOffset)
        shape.frame = CGRect(
            x: CGFloat((self.bounds.width - size.width) / 2.0),
            y: CGFloat((self.bounds.height - size.height) / 2.0),
            width: size.width,
            height: size.height)
        
        shape.setNeedsLayout()
    }
    
    func updateColors() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let switchColors = self.isHighlighted || self.isSelected
        
        if switchColors {
            if let downColor = self.downColor {
                self.displayView.fillColor = downColor
            }
            else {
                self.displayView.fillColor = self.color
            }
            
            if let downUnderColor = self.downUnderColor {
                self.underView.fillColor = downUnderColor
            }
            else {
                self.underView.fillColor = self.underColor
            }
            
            if let downBorderColor = self.downBorderColor {
                self.borderView.strokeColor = downBorderColor
            }
            else {
                self.borderView.strokeColor = self.borderColor
            }
            
            if let downTextColor = self.downTextColor {
                self.label.textColor = downTextColor
                self.popupLabel?.textColor = downTextColor
                self.shape?.color = downTextColor
            }
            else {
                self.label.textColor = self.textColor
                self.popupLabel?.textColor = self.textColor
                self.shape?.color = self.textColor
            }
        }
        else {
            self.displayView.fillColor = self.color
            
            self.underView.fillColor = self.underColor
            
            self.borderView.strokeColor = self.borderColor
            
            self.label.textColor = self.textColor
            self.popupLabel?.textColor = self.textColor
            self.shape?.color = self.textColor
        }
        
        if self.popup != nil {
            self.displayView.fillColor = self.popupColor
        }
        
        CATransaction.commit()
    }
    
    func layoutPopup(_ dir: Direction) {
        assert(self.popup != nil, "popup not found")
        
        if let popup = self.popup {
            if let delegate = self.delegate {
                let frame = delegate.popupFrame(for: self, direction: dir)
                popup.frame = frame
                popupLabel?.frame = popup.bounds
            }
            else {
                popup.frame = CGRect.zero
                popup.center = self.center
            }
        }
    }
    
    func configurePopup(_ direction: Direction) {
        assert(self.popup != nil, "popup not found")
        
        self.background.attach(direction)
        self.popup!.attach(direction.opposite)
        
        let kv = self.background
        let p = self.popup!
        
        self.connector?.removeFromSuperview()
        self.connector = KeyboardConnector(cornerRadius: 4, underOffset: self.underOffset, start: kv, end: p, startConnectable: kv, endConnectable: p, startDirection: direction, endDirection: direction.opposite)
        self.connector!.layer.zPosition = -1
        self.addSubview(self.connector!)
        
//        self.drawBorder = true
        
        if direction == Direction.up {
//            self.popup!.drawUnder = false
//            self.connector!.drawUnder = false
        }
    }
    
    func showPopup() {
        guard self.popup == nil else {
            return
        }
        
        self.layer.zPosition = 1000
        
        let popup = KeyboardKeyBackground(cornerRadius: 9.0, underOffset: self.underOffset)
        self.popup = popup
        self.addSubview(popup)
        
        let popupLabel = UILabel()
        popupLabel.textAlignment = self.label.textAlignment
        popupLabel.baselineAdjustment = self.label.baselineAdjustment
        popupLabel.font = self.label.font.withSize(22 * 2)
        popupLabel.adjustsFontSizeToFitWidth = self.label.adjustsFontSizeToFitWidth
        popupLabel.minimumScaleFactor = CGFloat(0.1)
        popupLabel.isUserInteractionEnabled = false
        popupLabel.numberOfLines = 1
        popupLabel.frame = popup.bounds
        popupLabel.text = self.label.text
        popup.addSubview(popupLabel)
        self.popupLabel = popupLabel
        
        self.label.isHidden = true
    }
    
    @objc func hidePopup() {
        guard self.popup != nil else {
            return
        }
        self.delegate?.willHidePopup(for: self)
        
        self.popupLabel?.removeFromSuperview()
        self.popupLabel = nil
        
        self.connector?.removeFromSuperview()
        self.connector = nil
        
        self.popup?.removeFromSuperview()
        self.popup = nil
        
        self.label.isHidden = false
        self.background.attach(nil)
        
        self.layer.zPosition = 0
    }
}
