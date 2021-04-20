//
//  NoNetworkPresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 10.03.2021.
//

import UIKit

protocol NoNetworkViewProtocol: UIViewController {
    
    var presenter: NoNetworkPresenterProtocol? { get set }
    
}

protocol NoNetworkPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, view: NoNetworkViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func updateNetwork()
    
}

class NoNetworkPresenter: NoNetworkPresenterProtocol {
    
    var router: GeneralRouterProtocol?
    var view: NoNetworkViewProtocol?
    
    required init(router: GeneralRouterProtocol, view: NoNetworkViewProtocol) {
        self.router = router
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        
    }
    
    func updateNetwork() {
        
    }
    
}
