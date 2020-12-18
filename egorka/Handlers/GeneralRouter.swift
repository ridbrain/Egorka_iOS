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
    
    func initialSplashView()
    func pushMainView()
    
}

class GeneralRouter: GeneralRouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblerBuilder: AssemblerBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblerBuilder: AssemblerBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblerBuilder = assemblerBuilder
    }
    
    func initialSplashView() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblerBuilder?.createSplashModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func pushMainView() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblerBuilder?.createMainModule(router: self) else { return }
            navigationController.show(mainViewController, navigationAnimationType: .autoReverse(presenting: .fade))
        }
    }
    
}
