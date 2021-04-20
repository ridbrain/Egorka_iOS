//
//  SideMenuProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 29.03.2021.
//

import UIKit

protocol SideMenuViewProtocol: UIViewController {
    
    var presenter: SideMenuPresenterProtocol? { get set }
    
}

protocol SideMenuPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, view: SideMenuViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    
    func openCurrentOrder()
    
}
