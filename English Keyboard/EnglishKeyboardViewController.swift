//
//  EnglishKeyboardViewController.swift
//  DemoKeyboard
//
//  Created by Robin Hill on 3/14/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import UIKit

import ErsatzKeyboard

class EnglishKeyboardViewController: TastyKeyboardViewController {
    var lastInsertedCharacterIsAutomaticSpace = false
    
    required init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        keyboard = englishKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func keyPressed(_ key: Key) {
        if lastInsertedCharacterIsAutomaticSpace && documentProxy().documentContextBeforeInput?.hasSuffix(" ") == true {
            let keyOuput = key.outputForCase(shiftState.uppercase())
            if !keyOuput.isEmpty && Array(" .,!?-/:;)]}").contains(keyOuput.first!) {
                documentProxy().deleteBackward()
            }
        }
        super.keyPressed(key)
        lastInsertedCharacterIsAutomaticSpace = false
    }
    
    override func backspaceDown(_ sender: KeyboardKey) {
        super.backspaceDown(sender)
        lastInsertedCharacterIsAutomaticSpace = false
    }
    
    func documentProxy() -> UITextDocumentProxy {
        return textDocumentProxy
    }
}
