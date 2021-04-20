//
//  AppDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 08.12.2020.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pushManager: NotificationHandler!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        pushManager = NotificationHandler()
        pushManager.registerForPushNotifications()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = UIColor.colorAccent
//        UINavigationBar.appearance().shadowImage = UIImage()
        
        let assemblerBuilder = AssemblerBuilder()
        let router = GeneralRouter(assemblerBuilder: assemblerBuilder)
        router.setSplashView()
        
        window?.rootViewController = router.getRootView()
        window?.makeKeyAndVisible()
        
        return true
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo.description)
        completionHandler(.newData)
    }

}
