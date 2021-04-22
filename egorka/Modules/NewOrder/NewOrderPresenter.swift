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
    var model: Delivery!
    
    var bottomView: NewOrderBottomProtocol!
    
    var pickups: [Location]?
    var drops: [Location]?
    
    required init(router: GeneralRouterProtocol, model: Delivery, view: NewOrderViewProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func viewDidLoad() {
        
        view?.setTitle(title: "Оформление заказа")
        view?.setTableViews()
        
        bottomView = NewOrderBottom()
        bottomView.presenter = self
        
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            DispatchQueue.main.async { [self] in
                if let view = view?.view {
                    bottomView.presentBottomView(view: view)
                }
            }
        }
        
    }
    
    func viewWillAppear() {
        
        updateArrays()
        
        view?.enableHero()
        view?.enableIQKeyboard()
        
    }
    
    func deleteLocation(type: LocationType, index: Int) {
        
//        switch type {
//        case .Pickup:
//            model.pickups?[index].Point = Point()
//        default:
//            model.drops?[index].Point = Point()
//        }
        
//        updateArrays()
        
    }
    
    func updateArrays() {
        
        guard let locations = model.Result?.Locations else { return }
        
        pickups = [Location]()
        drops = [Location]()
        
        locations.forEach { location in
            switch location.Type {
            case .Pickup:
                pickups!.append(location)
            case .Drop:
                drops!.append(location)
            case .none:
                break
            }
        }
        
//        var index = 1
//
//        model.pickups = model.pickups?.filter { $0.Point?.Code != nil }
//        model.drops = model.drops?.filter { $0.Point?.Code != nil }
//
//        model.pickups?.forEach { location in
//            location.RouteOrder = index
//            index = index + 1
//        }
//
//        model.drops?.forEach { location in
//            location.RouteOrder = index
//            index = index + 1
//        }
        
        if locations.count > 2 {
            view?.updateTables(pickups: pickups!, drops: drops!, numState: .full)
        } else {
            view?.updateTables(pickups: pickups!, drops:drops!, numState: .lite)
        }
        
        bottomView.setPrice(price: "\((model.Result!.TotalPrice!.Total ?? 0) / 100) ₽")
        bottomView.setTypeData(data: TypeData(type: model.Type!))
        
    }
    
    func viewWillDisappear() {
        
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
        
//        if let lastPickup = model.pickups?.last {
//
//            let newPickup = Location(suggestion: Dictionary.Suggestion(), type: .Pickup, routeOrder: lastPickup.RouteOrder! + 1)
//
//            model.pickups?.append(newPickup)
//            router?.openLocationDetails(model: newPickup, index: model.pickups!.count - 1)
//
//        }
        
    }
    
    func newDrop() {
        
//        if let lastDrop = model.drops?.last {
//
//            let newDrop = Location(suggestion: Dictionary.Suggestion(), type: .Drop, routeOrder: lastDrop.RouteOrder! + 1)
//
//            model.drops?.append(newDrop)
//            router?.openLocationDetails(model: newDrop, index: model.drops!.count - 1)
//
//        }
        
    }
    
}
