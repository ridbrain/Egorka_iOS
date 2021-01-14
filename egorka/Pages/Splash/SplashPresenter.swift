//
//  SplashPresenter.swift
//  egorka
//
//  Created by Виталий Яковлев on 22.12.2020.
//

import UIKit

protocol SplashViewProtocol: UIViewController {
    
    var presenter: SplashPresenterProtocol? { get set }
    
}

protocol SplashPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, view: SplashViewProtocol)
    
    func viewWillAppear()
    func viewWillDisappear()
}

class SplashPresenter: SplashPresenterProtocol {
    
    weak var view: SplashViewProtocol?
    var router: GeneralRouterProtocol?
    
    
    required init(router: GeneralRouterProtocol, view: SplashViewProtocol) {
        self.view = view
        self.router = router
    }
    
    func viewWillAppear() {
        view?.enableHero()
        DispatchQueue.global(qos: .background).async {
            usleep(5000)
            DispatchQueue.main.async { [self] in router?.openMainView() }
        }
    }
    
    func viewWillDisappear() {
        view?.disableHero()
    }
}
