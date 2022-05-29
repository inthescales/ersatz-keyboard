//  Created by Robin Hill on 5/28/22.
//  Copyright © 2022 Apple. All rights reserved.

/// State of the shift key
public enum ShiftState {
    case disabled
    case enabled
    case locked
    
    /// Whether this state uses uppercase letters.
    public var isUppercase: Bool {
        switch self {
        case .disabled:
            return false
        case .enabled:
            return true
        case .locked:
            return true
        }
    }
}
