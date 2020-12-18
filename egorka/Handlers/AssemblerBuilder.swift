//
//  AssemblerBuilder.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit

protocol AssemblerBuilderProtocol {
    
    func createSplashModule(router: GeneralRouterProtocol) -> UIViewController
    func createMainModule(router: GeneralRouterProtocol) -> UIViewController
    
}

class AssemblerBuilder: AssemblerBuilderProtocol {
    
    func createSplashModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = SplashViewController()
        view.router = router
        return view
    }
    
    func createMainModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presnter = MainPresenter(router: router, view: view)
        view.presenter = presnter
        return view
    }
    
}
