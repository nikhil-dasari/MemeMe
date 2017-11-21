//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Nikhil Dasari on 11/15/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {

    let memeTextAttributes: [String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5.0 ]
    
    //clear the placeholder text once the user taps into it
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }

    //when user clicks return button, relinquish the textfields status as first responder. This will dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func setDefaultTextFieldAttributes(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = self.memeTextAttributes
        textField.textAlignment = NSTextAlignment.center

        //set placeholder color
        let placeholderColor = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white])
        textField.attributedPlaceholder = placeholderColor
    }
}
