//
//  NoNetworkProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 22.04.2021.
//

import UIKit

protocol NoNetworkViewProtocol: UIViewController {
    
    var presenter: NoNetworkPresenterProtocol? { get set }
    
}

protocol NoNetworkPresenterProtocol: AnyObject {
    
    init(router: GeneralRouterProtocol, view: NoNetworkViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func updateNetwork()
    
}
