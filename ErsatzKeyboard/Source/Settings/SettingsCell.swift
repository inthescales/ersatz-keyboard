//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

import UIKit

/// Cell for the settings table view
final class SettingsCell: UITableViewCell {
    /// Toggle control for changing the setting's value
    private lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(SettingsCell.toggleTapped(_:)), for: .touchUpInside)
        return toggle
    }()
    
    /// Label attached to the toggle describing its function
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Longer comment label below the toggle
    // TODO(robin): Fix this or remove it. Maybe use a different cell type for this
    private lazy var longLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    /// Constraint pinning the toggle's bottom to the content view
    private lazy var toggleBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: toggle, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -4.0)
        constraint.isActive = true
        return constraint
    }()
    
    /// Constraint pinning the long label's bottom to the content view
    private lazy var longLabelBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: longLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -4.0)
        constraint.isActive = false
        return constraint
    }()
    
    /// The settings key controlled by this cell's toggle
    private var key: String?
    
    /// Closure called when the toggle is toggled
    private var didToggle: ((String, Bool) -> Void)?
    
    /// Configure this cell as a toggleable setting
    func configure(key: String, text: String, note: String?, didToggle: @escaping (String, Bool) -> Void) {
        self.key = key
        toggle.isHidden = false
        label.isHidden = false
        
        longLabel.isHidden = note == nil
        longLabelBottomConstraint.isActive = note != nil
        toggleBottomConstraint.isActive = note == nil
        updateConstraints()
        
        label.text = text
        longLabel.text = note
        self.didToggle = didToggle
    }
    
    /// Configure this cell as info
    func configureInfo(text: String, note: String?) {
        toggle.isHidden = true
        label.isHidden = true
        longLabel.isHidden = false
        
        longLabel.isHidden = note == nil
        longLabelBottomConstraint.isActive = note != nil
        toggleBottomConstraint.isActive = note == nil
        updateConstraints()
        
        label.text = text
        longLabel.text = note
        self.didToggle = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        [toggle, label, longLabel].forEach { contentView.addSubview($0) }

        // Toggle constraints
        addConstraints([
            NSLayoutConstraint(item: toggle, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: toggle, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 4.0),
            toggleBottomConstraint
        ])
        
        // Label constraints
        addConstraints([
            NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: label, attribute: .right, relatedBy: .lessThanOrEqual, toItem: toggle, attribute: .left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: toggle, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ])
                        
        // Long label constraints
        addConstraints([
            NSLayoutConstraint(item: longLabel, attribute: .top, relatedBy: .equal, toItem: toggle, attribute: .bottom, multiplier: 1.0, constant: -4.0),
            NSLayoutConstraint(item: longLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: longLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .width, multiplier: 1.0, constant: -16.0),
            longLabelBottomConstraint
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called when the toggle switch is tapped
    @objc func toggleTapped(_ sender: UISwitch) {
        didToggle?(key!, sender.isOn)
    }
}
