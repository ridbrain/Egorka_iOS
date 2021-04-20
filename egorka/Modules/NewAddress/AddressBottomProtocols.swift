//
//  AddressBottomProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 23.03.2021.
//

import UIKit

protocol AddressBottomViewProtocol: UIView {
    
    var presenter: DetailsPresenterProtocol? { get set }
    
    func presentBottomView(view: UIView, text: String)
    func setTableHeight(height: CGFloat)
    func setTextDelegate()
    func setSuggestions(suggestions: [Suggestion])
    func initTableView()
    func setAddressText(text: String)
    func dismiss()
    
}
