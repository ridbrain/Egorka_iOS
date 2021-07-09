//
//  MarketplacePresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 03.05.2021.
//

import UIKit
import MapKit

class MarketplacePresnter: MarketplacePresenterProtocol {
        
    weak var view: MarketplaceViewProtocol?
    var router: GeneralRouterProtocol?
    
    var locationHandler: LocationHandeler?
    var bottomOrder: NewOrderBottomProtocol!
    var bottomAddress: AddressBottomViewProtocol!
    
    var pickup: Location?
    var drop = Location()
    var places: [Location]?

    required init(router: GeneralRouterProtocol, view: MarketplaceViewProtocol) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        
        view?.setTitle(title: "Оформление заказа")
        
        locationHandler = LocationHandeler() {
            if let coordinate = self.locationHandler?.location?.coordinate {
                self.getAddress(location: coordinate)
            }
        }
        
        bottomOrder = NewOrderBottom()
        
        bottomAddress = AddressBottomSheet()
        bottomAddress.textDidChange = textDidChange(text:)
        bottomAddress.selectAddress = selectAddress(address:)
        bottomAddress.sheetHide = sheetHide
        
        Network.getMarketPlaces {
            self.view?.setPlacesDelegate(locations: $0)
            self.buildPlaces(locations: $0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let view = self.view?.view { self.bottomOrder.presentBottomView(view: view) }
        }
        
    }
    
    func viewWillAppear() {
        
        view?.enableHero()
        view?.enableIQKeyboard()
        
        calculateDelivery()
        
    }
    
    func viewWillDisappear() {
        
        view?.disableHero()
        view?.disableIQKeyboard()
        
    }
    
    func buildPlaces(locations: [Marketplaces.Point]) {
        
        places = [Location]()
        
        locations.forEach { point in
            places?.append(Location(marketplace: point, routeOrder: 1))
        }
        
    }
    
    func getAddress(location: CLLocationCoordinate2D) {
        
        GeocoderHandler.getAddress(coordinate: location) { address in
            
            Network.getAddress(address: address) { suggestions in
                
                let suggestion = suggestions[0]
                self.pickup = Location(suggestion: suggestion, type: .Pickup, routeOrder: 1)
                self.view?.setPickup(text: suggestion.Name!)
                self.calculateDelivery()
                
            }
            
        }
        
    }
    
    func selectAddress(address: Dictionary.Suggestion) {
        
        bottomAddress.setAddressText(text: address.Name!)
        
        if address.ID != nil {
            
            pickup = Location(suggestion: address, type: .Pickup, routeOrder: 1)
            view?.setPickup(text: address.Name!)
            bottomAddress.dismiss()
            calculateDelivery()
            
        } else {
            
            Network.getAddress(address: address.Name!) { suggestions in
                self.bottomAddress.setSuggestions(suggestions: suggestions)
            }
            
        }
        
        view?.enableIQKeyboard()
        
    }
    
    func sheetHide() {
        view?.enableIQKeyboard()
    }
    
    func textDidChange(text: String?) {
        
        if text == nil {
            bottomAddress.setSuggestions(suggestions: [Dictionary.Suggestion]())
        } else {
            Network.getAddress(address: text!) { suggestions in
                self.bottomAddress.setSuggestions(suggestions: suggestions)
            }
        }
        
    }
    
    func pressAddress() {
        
        view?.disableIQKeyboard()
        bottomAddress.presentBottomView(view: view!.view!, text: "Введите адрес")
        
    }
    
    func selectDropPlace(place: Marketplaces.Point) {
        
        if let name = place.Name?[0].Name {
            drop = Location(marketplace: place, routeOrder: 1)
            view?.setDrop(text: name)
            calculateDelivery()
        }
        
    }
    
    func calculateDelivery() {
        
        updateFields()
        
        guard let pickup = pickup?.getString() else { return }
        guard drop.Point?.Code != nil else { return }
        
        bottomOrder.transitionBottomView(index: 0)
        
        Network.calculateDelivery(locations: [pickup, drop.getString()], type: DeliveryType.Track) { delivery in
            self.showPrice(delivery: delivery)
        }
        
    }
    
    func updateFields() {
        
        if let pickupAddress = pickup?.Point?.Address { view?.setPickup(text: pickupAddress) }
        if let dropAddress = drop.Point?.Name { view?.setDrop(text: dropAddress) }
        
    }
    
    func showPrice(delivery: Delivery) {
        
//        bottomOrder.setInfoFields(type: TypeData(type: delivery.Type!), price: delivery.Result!.TotalPrice!)
        bottomOrder.transitionBottomView(index: 1)
        
    }
    
    func pressMyLocation() {
        
        if let location = pickup {
            router?.openAddressMap(location: location)
        } else {
            pickup = Location()
            router?.openAddressMap(location: pickup!)
        }
        
    }
    
    func pressMarketMap() {
        if let places = places { router?.openMarketplaceMap(location: drop, locations: places) }
    }
    
}
