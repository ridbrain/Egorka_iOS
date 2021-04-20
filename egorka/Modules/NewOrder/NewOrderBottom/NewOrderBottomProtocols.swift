//
//  NewOrderBottomProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 24.03.2021.
//

import UIKit

protocol NewOrderBottomProtocol: UIView {
    
    var presenter: NewOrderPresenter? { get set }
    
    func presentBottomView(view: UIView)
    func transitionBottomView(index: Int)
    
}
