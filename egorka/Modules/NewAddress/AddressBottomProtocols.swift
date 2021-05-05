//
//  AddressBottomProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 23.03.2021.
//

import UIKit

protocol AddressBottomViewProtocol: UIView {
    
    var textDidChange: ((String?) -> Void)? { get set }
    var selectAddress: ((Dictionary.Suggestion) -> Void)? { get set }
    var sheetHide: (() -> Void)? { get set }
    
    func presentBottomView(view: UIView, text: String)
    func setSuggestions(suggestions: [Dictionary.Suggestion])
    func setAddressText(text: String)
    func dismiss()
    
}
