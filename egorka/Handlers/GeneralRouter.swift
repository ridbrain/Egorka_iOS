//
//  GeneralRouter.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import Hero

protocol GeneralRouterProtocol {
    
    var navigationController: UINavigationController? { get set }
    var assemblerBuilder: AssemblerBuilderProtocol? { get set }
    
    func setSplashView()
    func openMainView()
    func openNewOrder(model: MainModeleProtocol)
    
}

class GeneralRouter: GeneralRouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblerBuilder: AssemblerBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblerBuilder: AssemblerBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblerBuilder = assemblerBuilder
    }
    
    func setSplashView() {
        if let navigationController = navigationController {
            guard let splashViewController = assemblerBuilder?.createSplashModule(router: self) else { return }
            navigationController.viewControllers = [splashViewController]
        }
    }
    
    func openMainView() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblerBuilder?.createMainModule(router: self) else { return }
            navigationController.show(mainViewController, navigationAnimationType: .autoReverse(presenting: .fade))
        }
    }
    
    func openNewOrder(model: MainModeleProtocol) {
        if let navigationController = navigationController {
            guard let newOrderViewController = assemblerBuilder?.createNewOrderModule(router: self, model: model) else { return }
            navigationController.show(newOrderViewController, navigationAnimationType: .slide(direction: .up))
        }
    }
    
}
