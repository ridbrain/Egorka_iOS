//
//  UserUUID.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 07.04.2021.
//

import UIKit

struct UserUUID: Codable {
    var ID: String?
    var Secure: String?
    var Status: String?
}

struct AnswerUser: Codable {
    var Time: String?
    var TimeStamp: Int?
    var Execution: Float?
    var Method: String?
    var Result: UserUUID?
}
