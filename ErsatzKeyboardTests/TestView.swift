//
//  TestView.swift
//  ErsatzKeyboardTests
//
//  Created by Robin Hill on 3/20/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

final class TestView: UIView {
    convenience init(device: TestDevice, view: UIView, height: CGFloat) {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: 1600 / 3,
            height: height
        )
        self.init(frame: frame)
        
        addSubview(view)
        view.frame = frame
    }
}
