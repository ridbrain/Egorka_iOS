//
//  MapPresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 05.05.2021.
//

import UIKit

class MapPresenter: MapPresenterProtocol {
    
    weak var view: MapViewProtocol?
    
    var locations: [Location]
    var location: Location
    
    required init(view: MapViewProtocol, location: Location, locations: [Location]) {
        self.view = view
        self.location = location
        self.locations = locations
    }
    
    func viewDidLoad() {
        view?.setPoints(loactions: locations)
    }
    
    func setLocation(location: Location) {
        
        self.location.Contact = location.Contact
        self.location.Date = location.Date
        self.location.ID = location.ID
        self.location.Point = location.Point
        self.location.Route = location.Route
        self.location.RouteOrder = location.RouteOrder
        self.location.Type = location.Type
        
        view?.navigationController?.popViewController(animated: true)
        
    }
    
}
