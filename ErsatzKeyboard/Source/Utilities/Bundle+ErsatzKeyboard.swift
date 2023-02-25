//
//  UIBundle+ErsatzKeyboard.swift
//  ErsatzKeyboard
//
//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation

extension Bundle {
    static var ersatzKeyboard = {
        Bundle(for: ErsatzKeyboardViewController.self)
    }()
}
