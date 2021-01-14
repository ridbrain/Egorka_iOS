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
    func createNewOrderModule(router: GeneralRouterProtocol, model: MainModeleProtocol) -> UIViewController
    
}

class AssemblerBuilder: AssemblerBuilderProtocol {

    func createSplashModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = SplashViewController()
        let presenter = SplashPresenter(router: router, view: view)
        view.presenter = presenter
        return view
    }
    
    func createMainModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presnter = MainPresenter(router: router, model: MainModel(), view: view)
        view.presenter = presnter
        return view
    }
    
    func createNewOrderModule(router: GeneralRouterProtocol, model: MainModeleProtocol) -> UIViewController {
        let view = NewOrderViewController()
        let presenter = NewOrderPresenter(router: router, model: model, view: view)
        view.presenter = presenter
        return view
    }
    
}
