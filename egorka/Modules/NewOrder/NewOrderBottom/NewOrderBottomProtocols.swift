//
//  NewOrderBottomProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 24.03.2021.
//

import UIKit

protocol NewOrderBottomProtocol: UIView {
    
    func presentBottomView(view: UIView)
    func transitionBottomView(index: Int)
    func setInfoFields(type: TypeData, price: Delivery.TotalPrice)
    
}
