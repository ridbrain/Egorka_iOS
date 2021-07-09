//
//  GeneralRouter.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import Hero

protocol GeneralRouterProtocol {
    
    var notificationCenter: NotificationCenter? { get set }
    var navigationController: UINavigationController! { get set }
    var assemblerBuilder: AssemblerBuilderProtocol? { get set }
    
    func getRootView() -> UINavigationController
    func setSplashView()
    func openMainView()
    func openNewOrder(model: Delivery)
    func openLocationDetails(model: Location, index: Int)
    func openCurrentOrder()
    func openSideMenu()
    func openAbout()
    func openMarketplace()
    func openMarketplaceMap(location: Location, locations: [Location])
    func openAddressMap(location: Location)
    
}

class GeneralRouter: GeneralRouterProtocol {
    
    var notificationCenter: NotificationCenter?
    var assemblerBuilder: AssemblerBuilderProtocol?
    var navigationController: UINavigationController! = UINavigationController()
    
    init(assemblerBuilder: AssemblerBuilderProtocol) {
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        self.assemblerBuilder = assemblerBuilder
        self.notificationCenter = NotificationCenter.default
        
        notificationCenter?.addObserver(
            self,
            selector: #selector(setNoNetworkView),
            name: NSNotification.Name(rawValue: "errorNoNetwork"),
            object: nil)
        
    }
    
    @objc func setNoNetworkView() {
        if !(navigationController.viewControllers.last is NoNetworkViewProtocol) {
            guard let noNetwork = assemblerBuilder?.createNoNetworkModule(router: self) else { return }
            navigationController.show(noNetwork, navigationAnimationType: .zoom)
        }
    }
    
    func getRootView() -> UINavigationController {
        return navigationController
    }
    
    func setSplashView() {
        guard let splashViewController = assemblerBuilder?.createSplashModule(router: self) else { return }
        navigationController.viewControllers = [splashViewController]
    }
    
    func openMainView() {
        guard let mainViewController = assemblerBuilder?.createMainModule(router: self) else { return }
        navigationController.show(mainViewController, navigationAnimationType: .autoReverse(presenting: .fade))
    }
    
    func openNewOrder(model: Delivery) {
        guard let newOrderViewController = assemblerBuilder?.createNewOrderModule(router: self, model: model) else { return }
        navigationController.show(newOrderViewController, navigationAnimationType: .selectBy(presenting: .slide(direction: .up), dismissing: .slide(direction: .down)))
    }
    
    func openLocationDetails(model: Location, index: Int) {
        guard let detailsViewController = assemblerBuilder?.createLocationDetails(router: self, model: model, index: index) else { return }
        navigationController.show(detailsViewController)
    }
    
    func openCurrentOrder() {
        guard let currenOrderViewController = assemblerBuilder?.createCurrenOrderModule(router: self) else { return }
        navigationController.show(currenOrderViewController)
    }
    
    func openSideMenu() {
        guard let sideMenu = assemblerBuilder?.createSideMenu(router: self) else { return }
        navigationController.present(sideMenu, animated: true, completion: nil)
    }
    
    func openAbout() {
        guard let aboutViewController = assemblerBuilder?.createAboutModule(router: self) else { return }
        navigationController.show(aboutViewController)
    }
    
    func openMarketplace() {
        guard let marketplaceViewController = assemblerBuilder?.createMarketplaceModule(router: self) else { return }
        navigationController.show(marketplaceViewController)
    }
    
    func openMarketplaceMap(location: Location, locations: [Location]) {
        guard let mapViewController = assemblerBuilder?.createMapModule(location: location, locations: locations) else { return }
        navigationController.show(mapViewController)
    }
    
    func openAddressMap(location: Location) {
        guard let mapViewController = assemblerBuilder?.createAddressMapModule(location: location) else { return }
        navigationController.show(mapViewController)
    }
    
}
