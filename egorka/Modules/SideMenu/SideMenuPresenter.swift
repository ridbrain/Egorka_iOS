//
//  SideMenuPresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 29.03.2021.
//

import UIKit

class SideMenuPresnter: SideMenuPresenterProtocol {
    
    weak var view: SideMenuViewProtocol?
    var router: GeneralRouterProtocol?
    
    required init(router: GeneralRouterProtocol, view: SideMenuViewProtocol) {
        self.router = router
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        
    }
    
    func openCurrentOrder() {
        router?.openCurrentOrder()
        view?.dismiss(animated: true, completion: nil)
    }
    
    func openAbout() {
        router?.openAbout()
        view?.dismiss(animated: true, completion: nil)
    }
    
    func openMarketplace() {
        router?.openMarketplace()
        view?.dismiss(animated: true, completion: nil)
    }
    
}
