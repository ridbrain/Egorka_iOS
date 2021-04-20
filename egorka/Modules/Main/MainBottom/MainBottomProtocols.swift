//
//  MainBottomProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 21.03.2021.
//

import UIKit

enum BottomState {
    case small
    case medium
    case big
}

enum FocusField {
    case pickup
    case drop
}

enum Causes {
    case changeRegion
    case selectField
}

protocol MainBottomViewProtocol: UIView {
    
    var presenter: MainPresenterProtocol? { get set }
    
    func initTextDelegate()
    func initTableView()
    func initCollectionView()
    func presentBottomView(view: UIView)
    func showTable(show: Bool, extra: CGFloat)
    func showButtons(show: Bool)
    func showWhere(show: Bool)
    func reloadCollection()
    func setKeyboardHeight(height: CGFloat)
    func transitionBottomView(state: BottomState)
    func getFocuseField() -> FocusField
    func setTextField(field: FocusField, text: String)
    func setSuggestions(suggestions: [Suggestion])
    func setFieldEdit(field: FocusField)
    func getTextFromField() -> [String]
    func changeIconPickupField(edit: Bool)
    func showIconDropField(show: Bool)
    
}
