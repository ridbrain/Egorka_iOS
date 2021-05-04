//
//  NewOrderPresenter.swift
//  egorka
//
//  Created by Виталий Яковлев on 24.12.2020.
//

import UIKit

class NewOrderPresenter: NewOrderPresenterProtocol {
    
    weak var view: NewOrderViewProtocol?
    var router: GeneralRouterProtocol?
    var delivery: Delivery!
    
    var bottomView: NewOrderBottomProtocol!
    
    required init(router: GeneralRouterProtocol, model: Delivery, view: NewOrderViewProtocol) {
        self.view = view
        self.delivery = model
        self.router = router
    }
    
    func viewDidLoad() {
        
        view?.setTitle(title: "Оформление заказа")
        view?.setTableViews()
        
        bottomView = NewOrderBottom()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let view = self.view?.view { self.bottomView.presentBottomView(view: view) }
        }
        
    }
    
    func viewWillAppear() {
        
        updateArrays()
        updateOrder()
        
        view?.enableHero()
        view?.enableIQKeyboard()
        
    }
    
    func updateOrder() {
        
        delivery.Result?.Locations = delivery.Result?.Locations?.filter { $0.Point?.Code != nil }
        delivery.restoreIndex()
        
        Network.calculateDelivery(locations: delivery.getLoactionsParameters(), type: delivery.Type!) { delivery in
            
            self.delivery = delivery
            self.updateArrays()
            self.updateBottomView()
            
        }
        
    }
    
    func deleteLocation(routeOrder: Int) {
        
        delivery.Result?.Locations = delivery.Result?.Locations?.filter { $0.RouteOrder != routeOrder }
        updateOrder()
        
    }
    
    func updateBottomView() {
        
        guard let totalPrice = delivery.Result?.TotalPrice else { return }
        guard let deliveryType = delivery.Type else { return }
        
        bottomView.setInfoFields(type: TypeData(type: deliveryType), price: totalPrice)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.bottomView.transitionBottomView(index: 1)
        }
        
    }
    
    func updateArrays() {
        
        delivery.Result?.Locations = delivery.Result?.Locations?.filter { $0.Point?.Code != nil }
        
        guard let locations = delivery.Result?.Locations else { return }
        
        let pickups = locations.filter { $0.Type == .Pickup }
        let drops = locations.filter { $0.Type == .Drop }
        
        if locations.count > 2 {
            view?.updateTables(pickups: pickups, drops: drops, numState: .full)
        } else {
            view?.updateTables(pickups: pickups, drops: drops, numState: .lite)
        }
        
    }
    
    func viewWillDisappear() {
        
        bottomView.transitionBottomView(index: 0)
        
        view?.disableHero()
        view?.disableIQKeyboard()
        
    }
    
    func openDetails(location: Location, index: Int) {
        
        router?.openLocationDetails(model: location, index: index)
        
    }
    
    func cancel() {
        
        view?.showWarning()
        
    }
    
    func newPickup() {
        
        guard let locations = delivery.Result?.Locations else { return }
        
        var pickups = locations
            .filter { $0.Type == .Pickup }
            .sorted { $0.RouteOrder! < $1.RouteOrder! }
        
        if let lastPickup = pickups.last {

            let newPickup = Location(suggestion: Dictionary.Suggestion(), type: .Pickup, routeOrder: lastPickup.RouteOrder! + 1)
            pickups.append(newPickup)
            
            let drops = locations.filter { $0.Type == .Drop }
            drops.forEach { location in location.RouteOrder = location.RouteOrder! + 1 }
            
            delivery.updateLocations(pickups: pickups, drops: drops)
            router?.openLocationDetails(model: newPickup, index: pickups.count - 1)

        }
        
    }
    
    func newDrop() {
        
        guard let locations = delivery.Result?.Locations else { return }
        
        var drops = locations
            .filter { $0.Type == .Drop }
            .sorted { $0.RouteOrder! < $1.RouteOrder! }
        
        if let lastDrop = drops.last {

            let newDrop = Location(suggestion: Dictionary.Suggestion(), type: .Drop, routeOrder: lastDrop.RouteOrder! + 1)
            drops.append(newDrop)
            
            delivery.updateLocations(pickups: locations.filter { $0.Type == .Pickup }, drops: drops)
            router?.openLocationDetails(model: newDrop, index: drops.count - 1)

        }
        
    }
    
}
