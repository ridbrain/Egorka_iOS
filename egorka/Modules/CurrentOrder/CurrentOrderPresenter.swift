//
//  CurrentOrderPresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 22.04.2021.
//

import UIKit

class CurrentOrderPresenter: CurrentOrderPresenterProtocol {
    
    weak var view: CurrentOrderViewProtocol?
    var router: GeneralRouterProtocol?
        
    required init(router: GeneralRouterProtocol, view: CurrentOrderViewProtocol) {
        self.router = router
        self.view = view
    }
    
    func viewDidLoad() {
        
        let pickup = Point()
        pickup.Latitude = 55.622868
        pickup.Longitude = 37.666306
        pickup.Address = "A1"
        let drop = Point()
        drop.Latitude = 55.637987
        drop.Longitude = 37.761285
        drop.Address = "B1"
        
        var locations = [NewOrderLocation]()
        
        locations.append(NewOrderLocation(suggestion: Suggestion(ID: "1", Name: "Cолнечная", Point: pickup), type: .Pickup, routeOrder: 1))
        locations.append(NewOrderLocation(suggestion: Suggestion(ID: "2", Name: "Паромная", Point: drop), type: .Drop, routeOrder: 2))
        
        view?.setRoute(pickup: pickup, drop: drop)
        view?.updateTables(locations: locations)
        
    }
    
}
