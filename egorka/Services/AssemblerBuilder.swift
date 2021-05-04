//
//  AssemblerBuilder.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import SideMenu

protocol AssemblerBuilderProtocol {
    
    func createSplashModule(router: GeneralRouterProtocol) -> UIViewController
    func createNoNetworkModule(router: GeneralRouterProtocol) -> UIViewController
    func createMainModule(router: GeneralRouterProtocol) -> UIViewController
    func createNewOrderModule(router: GeneralRouterProtocol, model: Delivery) -> UIViewController
    func createLocationDetails(router: GeneralRouterProtocol, model: Location, index: Int) -> UIViewController
    func createSideMenu(router: GeneralRouterProtocol) -> UIViewController
    func createCurrenOrderModule(router: GeneralRouterProtocol) -> UIViewController
    func createAboutModule(router: GeneralRouterProtocol) -> UIViewController
    func createMarketplaceModule(router: GeneralRouterProtocol) -> UIViewController
    
}

class AssemblerBuilder: AssemblerBuilderProtocol {

    func createSplashModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = SplashViewController()
        let presenter = SplashPresenter(router: router, view: view)
        view.presenter = presenter
        return view
    }
    
    func createNoNetworkModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = NoNetworkViewController()
        let presenter = NoNetworkPresenter(router: router, view: view)
        view.presenter = presenter
        return view
    }
    
    func createMainModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presnter = MainPresenter(router: router, view: view)
        view.presenter = presnter
        return view
    }
    
    func createNewOrderModule(router: GeneralRouterProtocol, model: Delivery) -> UIViewController {
        let view = NewOrderViewController()
        let presenter = NewOrderPresenter(router: router, model: model, view: view)
        view.presenter = presenter
        return view
    }
    
    func createLocationDetails(router: GeneralRouterProtocol, model: Location, index: Int) -> UIViewController {
        let view = DetailsViewController()
        let presenter = DetailsPresenter(router: router, model: model, view: view, index: index)
        view.presenter = presenter
        return view
    }
    
    func createSideMenu(router: GeneralRouterProtocol) -> UIViewController {
        
        let view = SideMenuViewController()
        let presenter = SideMenuPresnter(router: router, view: view)
        let sideMenu = SideMenuNavigationController(rootViewController: view)
        
        sideMenu.leftSide = true
        sideMenu.presentationStyle = .menuSlideIn
        sideMenu.blurEffectStyle = .light
        sideMenu.setNavigationBarHidden(true, animated: false)
        
        view.presenter = presenter
        
        return sideMenu
        
    }
    
    func createCurrenOrderModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = CurrentOrderViewController()
        let presenter = CurrentOrderPresenter(router: router, view: view)
        view.presenter = presenter
        return view
    }
    
    func createAboutModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = AboutViewController()
        let presenter = AboutPresenter(router: router, view: view)
        view.presenter = presenter
        return view
    }
    
    func createMarketplaceModule(router: GeneralRouterProtocol) -> UIViewController {
        let view = MarketplaceViewController()
        let presenter = MarketplacePresnter(router: router, view: view)
        view.presenter = presenter
        return view
    }
    
}
