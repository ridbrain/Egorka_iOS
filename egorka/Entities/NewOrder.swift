//
//  Location.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 15.03.2021.
//

import UIKit
import Alamofire
import MapKit

struct Marketplaces: Codable {
    
    var Time: String?
    var TimeStamp: Int?
    var Execution: Float?
    var Method: String?
    var Result: Result?
    
    struct Result: Codable {
        var Cached: Bool?
        var Points: [Point]?
    }
    
    struct Point: Codable {
        
        var ID: String?
        var Code: String?
        var Latitude: Double?
        var Longitude: Double?
        var Name: [Name]?
        var Address: [Address]?
        
        struct Name: Codable {
            var Name: String?
            var Language: String?
        }
        
        struct Address: Codable {
            var Address: String?
            var Language: String?
        }
        
    }
    
}

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
        case .Track:
            label = "Грузовой"
            icon = .icTrack
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
        var Invoices: [Invoice]?
        
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
    
    class Invoice: Codable {
        var ID: Int?
        var PIN: Int?
    }
    
    func restoreIndex() {
        
        var index = 1
        
        self.Result?.Locations?.forEach { location in
            
            location.ID = "\(location.Type!.rawValue)-\(index)"
            location.Route = 1
            location.RouteOrder = index
            
            index = index + 1
            
        }
        
    }
    
    func updateLocations(pickups: [Location], drops: [Location]) {
        
        self.Result?.Locations = [Location]()
        
        pickups.forEach { location in self.Result?.Locations?.append(location) }
        drops.forEach { location in self.Result?.Locations?.append(location) }
        
    }
    
    func getLoactionsParameters() -> [Any] {
        
        var array = [Any]()
        self.Result?.Locations?.forEach { location in array.append(location.getString()) }
        
        return array
        
    }
    
}

class Location: Codable {
    
    var ID: String?
    var Date: String?
    var Route: Int?
    var RouteOrder: Int?
    var Point: Point?
    var Contact: Contact?
    var Message: String?
    var `Type`: LocationType?
    
    init() { }
    
    init(marketplace: Marketplaces.Point, routeOrder: Int) {
        
        let point = egorka.Point()
        point.Address = marketplace.Address?[0].Address
        point.Code = marketplace.Code
        point.Latitude = marketplace.Latitude
        point.Longitude = marketplace.Longitude
        point.Name = marketplace.Name?[0].Name
        
        self.ID = "\(LocationType.Drop.rawValue)-\(routeOrder)"
        self.Date = nil
        self.Type = LocationType.Drop
        self.Route = 1
        self.RouteOrder = routeOrder
        self.Point = point
        self.Contact = nil
        self.Message = nil
        
    }
    
    init(suggestion: Dictionary.Suggestion, type: LocationType, routeOrder: Int) {
        
        let point = suggestion.Point
        point?.Code = suggestion.ID
        point?.Address = suggestion.Name
        
        self.ID = "\(type.rawValue)-\(routeOrder)"
        self.Date = nil
        self.Type = type
        self.Route = 1
        self.RouteOrder = routeOrder
        self.Point = point
        self.Contact = nil
        self.Message = nil
        
    }
    
    func getString() -> Parameters {
        
        return [
            "ID" : ID ?? "",
            "Date" : Date ?? "",
            "Route" : Route ?? "",
            "RouteOrder" : RouteOrder ?? "",
            "Point" : Point?.getString() ?? "",
            "Type" : Type?.rawValue ?? "",
            "Contact" : Contact?.getString() ?? "",
            "Message" : Message ?? ""
        ] as Parameters
        
    }
    
}

class Point: Codable {
    
    var Address: String?
    var Name: String?
    var Code: String?
    var Latitude: Double?
    var Longitude: Double?
    var Entrance: String?
    var Floor: String?
    var Room: String?
    
    init() { }
    
    init(coordinate: CLLocationCoordinate2D) {
        Latitude = coordinate.latitude
        Longitude = coordinate.longitude
    }
    
    func getString() -> Parameters {
        
        return [
            "Address" : Address ?? "",
            "Code" : Code ?? "",
            "Latitude" : Latitude ?? "",
            "Longitude" : Longitude ?? "",
            "Entrance" : Entrance ?? "",
            "Floor" : Floor ?? "",
            "Room" : Room ?? ""
        ] as Parameters
        
    }
    
}

class Contact: Codable {
    
    var Name: String?
    var Department: String?
    var PhoneMobile: String?
    var PhoneOffice: String?
    var PhoneOfficeAdd: String?
    var EmailPersonal: String?
    var EmailOffice: String?
    
    func getString() -> Parameters {
        
        return [
            "Name" : Name ?? "",
            "Department" : Department ?? "",
            "PhoneMobile" : PhoneMobile ?? "",
            "PhoneOffice" : PhoneOffice ?? "",
            "PhoneOfficeAdd" : PhoneOfficeAdd ?? "",
            "EmailPersonal" : EmailPersonal ?? "",
            "EmailOffice" : EmailOffice ?? ""
        ] as Parameters
        
    }
    
}

struct Payment: Codable {
    var Success: Bool?
    var ErrorCode, TerminalKey, Status, PaymentId: String?
    var OrderId: String?
    var Amount: Int?
    var PaymentURL: String?
}

enum LocationType: String, Codable {
    case Pickup
    case Drop
}

enum DeliveryType: String, Codable {
    case Walk
    case Car
    case Track
}
