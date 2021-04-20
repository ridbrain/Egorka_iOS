//
//  DataHandler.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 07.04.2021.
//

import UIKit

class UserData {
    
    static let UUID = "EgorkaUserUIID"
    static let SECURE = "EgorkaUserSecure"
    static let FIREBASE = "EgorkaUserFCM"
    
    static let defaults = UserDefaults.standard
    
    class func isUserUUID() -> Bool {
        return getUserUUID() != nil
    }
    
    class func setUserUUID(uuid: String) {
        defaults.set(uuid, forKey: UUID)
    }
    
    class func getUserUUID() -> String? {
        return defaults.string(forKey: UUID)
    }
    
    class func setUserSecure(seceure: String) {
        defaults.set(seceure, forKey: SECURE)
    }
    
    class func getUserSecure() -> String? {
        return defaults.string(forKey: SECURE)
    }
    
    class func setUserFCM(fcm: String) {
        defaults.set(fcm, forKey: FIREBASE)
    }
    
    class func getUserFCM() -> String? {
        return defaults.string(forKey: FIREBASE)
    }
    
}
