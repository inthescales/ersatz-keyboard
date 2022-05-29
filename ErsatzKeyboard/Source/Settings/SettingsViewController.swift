//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

import UIKit

/// Settings panel view controller
final class SettingsViewController: UIViewController {
    private enum Constants {
        /// The height of the faux nav bar at the bottom of settings
        static let navBarHeight: CGFloat = 44.0
    }
    
    /// Table view containing the settings items
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 44;
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: Constants.navBarHeight, right: 0.0)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // On iOS 11 (maybe others too) an extra margin is added at the top. This removes it.
        if #available(iOSApplicationExtension 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        return tableView
    }()
    
    /// Faux nav-bar view on the bottom of the settings panel, with a back button
    private lazy var fauxNavBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        // Add blur effect
        // TODO(robin): make sure blur works in light and dark mode
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.backgroundColor = .clear
        view.addSubview(effectView)
        view.addEdgeMatchedSubview(effectView)
        
        // Add 'settings' label
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        view.addSubview(settingsLabel)
        view.addConstraints([
            NSLayoutConstraint(item: settingsLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: settingsLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ])
        
        // Add back button
        let backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.addTarget(self, action: #selector(SettingsViewController.didTapBack), for: .touchUpInside)
        view.addSubview(backButton)
        view.addConstraints([
            NSLayoutConstraint(item: backButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 8.0)
        ])
       
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: Constants.navBarHeight))
        
        [view, effectView, settingsLabel, backButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
       
        return view
    }()
    
    /// Settings to display
    let settingsConfig: SettingsConfiguration
    
    /// Provider for actual setting values
    let settingsProvider: SettingsProvider
    
    /// Closure called when back button is tapped
    @objc let backTapped: () -> Void

    init(settingsList: SettingsConfiguration, settingsProvider: SettingsProvider, backTapped: @escaping () -> Void) {
        self.settingsConfig = settingsList
        self.settingsProvider = settingsProvider
        self.backTapped = backTapped
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addEdgeMatchedSubview(tableView)
        view.addSubview(fauxNavBarView)
        view.addConstraints([
            NSLayoutConstraint(item: fauxNavBarView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: fauxNavBarView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: fauxNavBarView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
        
        tableView.reloadData()
    }
    
    /// Called when a setting has been toggled
    private func toggled(setting key: String, to value: Bool) {
        settingsProvider.setValue(for: key, to: value)
    }
    
    /// Called when the back button is tapped
    @objc private func didTapBack() {
        backTapped()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingsConfig.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsConfig.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingsConfig.sections[section].title
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SettingsCell {
            let row = self.settingsConfig.sections[indexPath.section].rows[indexPath.row]
            // TODO(robin): Put notes here again when the cell works
            cell.configure(
                key: row.setting.key,
                text: row.title,
                note: nil,
                isToggledOn: settingsProvider.value(for: row.setting.key),
                didToggle: { [weak self] key, toggleOn in
                self?.toggled(setting: key, to: toggleOn)
            })
            cell.selectionStyle = .none
            return cell
        }
        else {
            assert(false, "this is a bad thing that just happened")
            return UITableViewCell()
        }
    }
}
