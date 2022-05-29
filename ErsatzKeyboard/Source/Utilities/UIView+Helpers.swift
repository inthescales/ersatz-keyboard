//
//  UIViewController+Helpers.swift
//  ErsatzKeyboard
//
//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

extension UIView {
    func addEdgeMatchedSubview(_ childView: UIView) {
        addSubview(childView)
        addConstraints([
            NSLayoutConstraint(item: childView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: childView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
    }
}
