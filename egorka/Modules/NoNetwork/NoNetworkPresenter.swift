//
//  NoNetworkPresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 10.03.2021.
//

import UIKit

class NoNetworkPresenter: NoNetworkPresenterProtocol {
    
    var router: GeneralRouterProtocol?
    weak var view: NoNetworkViewProtocol?
    
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
        router?.openMainView()
    }
    
}
