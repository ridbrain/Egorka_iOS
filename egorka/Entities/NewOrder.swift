//
//  Location.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 15.03.2021.
//

import UIKit

struct Dictionary: Codable {
    
    var Time: String?
    var TimeStamp: Int?
    var Execution: Float?
    var Method: String?
    var Result: Result?
    
    struct Result: Codable {
        var Cached: Bool?
        var Suggestions: [Suggestion]?
    }
    
    struct Suggestion: Codable {
        var ID: String?
        var Name: String?
        var Point: Point?
    }
    
}

class TypeData {
    
    var icon: UIImage
    var label: String
    
    init(type: DeliveryType) {
        switch type {
        case .Car:
            label = "Легковой"
            icon = .icCar
        case .Walk:
            label = "Пеший"
            icon = .icWalk
        }
    }
    
}

class Delivery: Codable {
    
    var Time: String?
    var TimeStamp: Int?
    var Execution: Float?
    var Method: String?
    var Result: Result?
    var `Type`: DeliveryType?
    
    class Result: Codable {
        
        var ID: String?
        var Date: Int?
        var DateUpdate: Int?
        var Stage: Bool?
        var RecordNumber: Int?
        var RecordPIN: Int?
        var RecordDate: String?
        var RecordDateStamp: Int?
        var Locations: [Location]?
        var TotalPrice: TotalPrice?
        
    }
    
    class TotalPrice: Codable {
        var Base: Int?
        var Ancillary: Int?
        var Discount: Int?
        var Compensation: Int?
        var Bonus: Int?
        var Tip: Int?
        var Total: Int?
        var Currency: String?
    }
    
}

class Location: Codable {
    
    var ID: String {
        return "\(self.Type?.rawValue ?? "")-\(self.RouteOrder ?? 0)"
    }
    
    var Date: String?
    var Route: Int?
    var RouteOrder: Int?
    var Point: Point?
    var Contact: Contact?
    var Message: String?
    var `Type`: LocationType?
    
    init(suggestion: Dictionary.Suggestion, type: LocationType, routeOrder: Int) {
        
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

enum DeliveryType: String, Codable {
    case Walk
    case Car
}
