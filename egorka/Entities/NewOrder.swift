//
//  Location.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 15.03.2021.
//

import Foundation

struct Suggestion: Codable {
    var ID: String?
    var Name: String?
    var Point: Point?
}

struct Result: Codable {
    var Cached: Bool?
    var Suggestions: [Suggestion]?
}

struct Dictionary: Codable {
    var Time: String?
    var TimeStamp: Int?
    var Execution: Float?
    var Method: String?
    var Result: Result?
}

class NewOrderLocation: Codable {
    
    var ID: String {
        return "\(self.Type?.rawValue ?? "")-\(self.RouteOrder ?? 0)"
    }
    
    var `Type`: LocationType?
    var Date: String?
    var Route: Int?
    var RouteOrder: Int?
    var Point: Point?
    var Contact: Contact?
    var Message: String?
    
    init(suggestion: Suggestion, type: LocationType, routeOrder: Int) {
        
        let point = suggestion.Point
        point?.Code = suggestion.ID
        point?.Address = suggestion.Name
        
        self.Date = nil
        self.Type = type
        self.Route = 1
        self.RouteOrder = routeOrder
        self.Point = point
        self.Contact = nil
        self.Message = nil
        
    }
    
}

class Point: Codable {
    
    var Address: String?
    var Code: String?
    var Latitude: Double?
    var Longitude: Double?
    var Entrance: Int?
    var Floor: Int?
    var Room: Int?
    
}

class Contact: Codable {
    
    var Name: String?
    var Department: String?
    var PhoneMobile: String?
    var PhoneOffice: String?
    var PhoneOfficeAdd: String?
    var EmailPersonal: String?
    var EmailOffice: String?
    
}

enum LocationType: String, Codable {
    
    case Pickup
    case Drop
    
}
