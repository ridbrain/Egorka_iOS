//
//  SelectBottomSheetProtocol.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 11.05.2021.
//

import UIKit

protocol SelectBottomViewProtocol: UIView {
    
    func presentBottomView(view: UIView, label: String, select: @escaping () -> Void)
    func updateAddress(address: String)
    func hideSelectButton()
    
}
