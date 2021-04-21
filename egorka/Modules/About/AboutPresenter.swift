//
//  AboutPresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 21.04.2021.
//

import UIKit

class AboutPresenter: AboutPresenterProtocol {
        
    weak var view: AboutViewProtocol?
    var router: GeneralRouterProtocol?
    
    required init(router: GeneralRouterProtocol, view: AboutViewProtocol) {
        self.router = router
        self.view = view
    }
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        
    }
    
    func pressVersion() {
        UIPasteboard.general.string = UserData.getUserFCM()
    }
    
}
