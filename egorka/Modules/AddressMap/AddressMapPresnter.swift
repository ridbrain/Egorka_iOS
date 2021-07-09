//
//  AddressMapPresnter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 16.05.2021.
//

import UIKit
import MapKit

class AddressMapPresnter: AddressMapPresenterProtocol {
    
    weak var view: AddressMapViewProtocol?
    var selected: Location!
    
    var new: Location?
    var bottomView: SelectBottomViewProtocol!
    
    required init(view: AddressMapViewProtocol, location: Location) {
        self.view = view
        self.selected = location
    }
    
    func viewDidLoad() {
        
        view?.setTitle(title: "Карта")
        
        bottomView = SelectBottomSheet()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let view = self.view?.view {
                self.bottomView.presentBottomView(view: view, label: "Укажите адрес") {
                    self.selectLocation()
                }
                self.getCoordinate()
            }
        }
        
    }
    
    func getCoordinate() {
        
        if let point = selected.Point {
            view?.setCoordinate(with: CLLocationCoordinate2D(latitude: point.Latitude!, longitude: point.Longitude!))
        }
        
    }
    
    func setLocation(coordinate: CLLocationCoordinate2D) {
        
        GeocoderHandler.getAddress(coordinate: coordinate) { address in
            
            Network.getAddress(address: address) { suggestions in
                
                self.new = Location(suggestion: suggestions[0], type: .Pickup, routeOrder: 1)
                
                if let address = self.new?.Point?.Address {
                    self.bottomView.updateAddress(address: address)
                }
                
            }
            
        }
        
    }
    
    func selectLocation() {
        
        if let location = new {
            
            selected.Contact = location.Contact
            selected.Date = location.Date
            selected.ID = location.ID
            selected.Point = location.Point
            selected.Route = location.Route
            selected.RouteOrder = location.RouteOrder
            selected.Type = location.Type
            
            view?.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
}
