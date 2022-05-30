//  Created by Alexei Baboulevitch on 7/10/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.

import Foundation

var counter = 0

public class Key: Hashable {
    public enum KeyType {
        case character
        case specialCharacter
        case shift
        case backspace
        case modeChange
        case keyboardChange
        case period
        case space
        case `return`
        case settings
        case other
    }
    
    public var type: KeyType
    public var uppercaseKeyCap: String?
    public var lowercaseKeyCap: String?
    public var uppercaseOutput: String?
    public var lowercaseOutput: String?
    
    /// If the key is a mode button, this indicates which page it links to
    public var toMode: Int?
    
    /// Whether this key represents a character
    public var isCharacter: Bool {
        get {
            switch self.type {
            case
            .character,
            .specialCharacter,
            .period:
                return true
            default:
                return false
            }
        }
    }
    
    /// Whether this is a special key (shift, backspace, mode, etc)
    public var isSpecial: Bool {
        get {
            switch self.type {
            case .shift:
                return true
            case .backspace:
                return true
            case .modeChange:
                return true
            case .keyboardChange:
                return true
            case .return:
                return true
            case .settings:
                return true
            default:
                return false
            }
        }
    }
    
    /// Whether this key produces text output when tapped
    public var hasOutput: Bool {
        get {
            return (self.uppercaseOutput != nil) || (self.lowercaseOutput != nil)
        }
    }
    
    // TODO: this is kind of a hack
    public var hashValue: Int
    
    public init(_ type: KeyType) {
        self.type = type
        self.hashValue = counter
        counter += 1
    }
    
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.hashValue)
    }
    
    convenience public init(_ key: Key) {
        self.init(key.type)
        
        self.uppercaseKeyCap = key.uppercaseKeyCap
        self.lowercaseKeyCap = key.lowercaseKeyCap
        self.uppercaseOutput = key.uppercaseOutput
        self.lowercaseOutput = key.lowercaseOutput
        self.toMode = key.toMode
    }
    
    public func setLetter(_ letter: String) {
        self.lowercaseOutput = letter.lowercased()
        self.uppercaseOutput = letter.uppercased()
        self.lowercaseKeyCap = self.lowercaseOutput
        self.uppercaseKeyCap = self.uppercaseOutput
    }
    
    public func outputForCase(_ uppercase: Bool) -> String {
        if uppercase {
            return uppercaseOutput ?? lowercaseOutput ?? ""
        }
        else {
            return lowercaseOutput ?? uppercaseOutput ?? ""
        }
    }
    
    public func keyCapForCase(_ uppercase: Bool) -> String {
        if uppercase {
            return uppercaseKeyCap ?? lowercaseKeyCap ?? ""
        }
        else {
            return lowercaseKeyCap ?? uppercaseKeyCap ?? ""
        }
    }

    public var customRender : ((_ key: KeyboardKey, _ fullReset: Bool, _ uppercase: Bool, _ characterUppercase: Bool, _ shiftState: ShiftState) -> (Void))?

    public var customAppearance : ((_ key: KeyboardKey, _ darkMode: Bool, _ solidColorMode: Bool) -> (Void))?
}

extension Key: Equatable {
    public static func ==(lhs: Key, rhs: Key) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
