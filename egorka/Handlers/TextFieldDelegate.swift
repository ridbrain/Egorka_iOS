//
//  TextFieldDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 12.12.2020.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var text: String!
    var identifier: String = ""
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        identifier = textField.restorationIdentifier ?? ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && range.length == 1 {
            text = ""
        } else if range.length == 1 {
            text = String(textField.text!.dropLast())
        } else {
            text = String(textField.text! + string)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "textDidChange"), object: nil)
        
        return true
        
    }
    
}
