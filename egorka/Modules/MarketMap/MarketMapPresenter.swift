//
//  MapPresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 05.05.2021.
//

import UIKit

class MarketMapPresenter: MarketMapPresenterProtocol {

    weak var view: MarketMapViewProtocol?
    
    var bottomView: SelectBottomViewProtocol!
    
    var locations: [Location]
    var selected: Location
    var new: Location?
    
    required init(view: MarketMapViewProtocol, location: Location, locations: [Location]) {
        self.view = view
        self.selected = location
        self.locations = locations
    }
    
    func viewDidLoad() {
        
        view?.setPoints(title: "Маркетплейсы", loactions: locations)
        bottomView = SelectBottomSheet()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let view = self.view?.view {
                self.bottomView.presentBottomView(view: view, label: "Выберите адрес") {
                    self.selectLocation()
                }
            }
        }
        
    }
    
    func setLocation(location: Location) {
        
        new = location
        bottomView.updateAddress(address: location.Point!.Address!)
        
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
