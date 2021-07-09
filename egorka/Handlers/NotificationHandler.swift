//
//  PushNotificationManager.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 29.03.2021.
//

import Firebase
import FirebaseMessaging
import UserNotifications

class NotificationHandler: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {

        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, error in
            if let error = error { print(error.localizedDescription); return }
        }
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        UIApplication.shared.registerForRemoteNotifications()
        
        updateFirestorePushTokenIfNeeded()
        
    }
    
    func updateFirestorePushTokenIfNeeded() {
        
        if let token = Messaging.messaging().fcmToken { UserData.setUserFCM(fcm: token) }
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        updateFirestorePushTokenIfNeeded()
        
    }
    
}
