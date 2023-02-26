//  Created by Robin Hill on 2/25/23.
//  Copyright © 2023 Apple. All rights reserved.
//

import UIKit

/// Color theme for a keyboard key
struct KeyboardKeyColors {
    let capColor: UIColor
    let underColor: UIColor
    let borderColor: UIColor
    let textColor: UIColor
    
    let downColor: UIColor?
    let downUnderColor: UIColor?
    let downBorderColor: UIColor?
    let downTextColor: UIColor?
    
    let popupColor: UIColor?
    
    init(
        capColor: UIColor,
        underColor: UIColor,
        borderColor: UIColor,
        textColor: UIColor,
        downColor: UIColor? = nil,
        downUnderColor: UIColor? = nil,
        downBorderColor: UIColor? = nil,
        downTextColor: UIColor? = nil,
        popupColor: UIColor? = nil
    ) {
        self.capColor = capColor
        self.underColor = underColor
        self.borderColor = borderColor
        self.textColor = textColor
        self.downColor = downColor
        self.downUnderColor = downUnderColor
        self.downBorderColor = downBorderColor
        self.downTextColor = downTextColor
        self.popupColor = popupColor
    }
    
    static var standard = {
        KeyboardKeyColors(
            capColor: .white,
            underColor: .gray,
            borderColor: .black,
            textColor: .black,
            popupColor: .white
        )
    }()
}
