//
//  TextFieldDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 12.12.2020.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var complition: (String?) -> Void
    
    required init(complition: @escaping (String?) -> Void) {
        self.complition = complition
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && range.length == 1 {
            complition(nil)
        } else if range.length == 1 {
            complition(String(textField.text!.dropLast()))
        } else {
            complition(String(textField.text! + string))
        }
        
        return true
        
    }
    
}
