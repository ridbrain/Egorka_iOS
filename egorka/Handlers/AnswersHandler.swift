//
//  AnswersHandler.swift
//  egorka
//
//  Created by Виталий Яковлев on 11.12.2020.
//

import Foundation

struct Point: Codable {
    var Latitude: Double?
    var Longitude: Double?
}

struct Address: Codable {
    var ID: String?
    var Name: String?
    var Point: Point?
}

struct Result: Codable {
    var Cached: Bool?
    var Suggestions: [Address]?
}

struct Dictionary: Codable {
    var Time: String?
    var TimeStamp: Int?
    var Execution: Float?
    var Method: String?
    var Result: Result?
}
