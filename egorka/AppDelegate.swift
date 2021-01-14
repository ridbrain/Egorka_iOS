//
//  AppDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 08.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let assemblerBuilder = AssemblerBuilder()
        let router = GeneralRouter(navigationController: navigationController, assemblerBuilder: assemblerBuilder)
        router.setSplashView()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
        
    }

}
