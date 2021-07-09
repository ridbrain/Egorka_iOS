//
//  MainPresenter.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import MapKit

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: GeneralRouterProtocol?
    
    var locationHandler: LocationHandeler!
    var bottomView: MainBottomViewProtocol!

    var routeLaid = false
    var keyboardHide = true
    
    var pickup: Location?
    var drop: Location?
    var delivery: Delivery?
    
    required init(router: GeneralRouterProtocol, view: MainViewProtocol) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        
        view?.setMapDelegate()
        
        locationHandler = LocationHandeler() {
            if let coordinate = self.locationHandler.location?.coordinate {
                self.view?.setMapRegion(coordinate: coordinate)
            }
        }
        
    }
    
    func viewWillAppear() {
        
        view?.enableHero()
        view?.hideNavBar()
        
        setNotificationCenter()
        
        if bottomView == nil {
            
            bottomView = MainBottomSheet()
            bottomView.presenter = self
            
            bottomView.initTextDelegate()
            bottomView.initTableView()
            bottomView.initCollectionView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let view = self.view?.view {
                    self.bottomView.presentBottomView(view: view)
                }
            }
            
            bottomView.showTable(show: false)
            bottomView.showButtons(show: routeLaid)
            
        } else if routeLaid {
            
            deleteRout(causes: .changeRegion)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.moveMyLocation()
            }
            
        } else {
            
            updateDrop()
            
        }
        
//        bottomView.reloadCollection(types: [Delivery]())
        
    }
    
    func viewWillDisappear() {
        
        removeNotificationCenter()
        
        view?.deleteRout()
        view?.disableHero()
        
        bottomView.transitionBottomView(state: .small)
        bottomView.showButtons(show: false)
        
    }
    
    func setNotificationCenter() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UITextField.keyboardWillShowNotification,
            object: nil)
        
    }
    
    func removeNotificationCenter() {
        
        NotificationCenter.default.removeObserver(self, name: UITextField.keyboardWillShowNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            bottomView.setKeyboardHeight(height: keyboardFrame.cgRectValue.height)
        }
        
        if keyboardHide {
            
            openBottomView()
            
            if routeLaid {
                
                view?.showChangeAlert { answer in
                    if answer {
                        self.deleteRout(causes: .selectField)
                        self.setEditButtons()
                    } else {
                        self.hideKeyboard()
                    }
                }
                
            }
            
        }
        
        setEditButtons()
        
        keyboardHide = false

    }
    
    func setEditButtons() {
        
        switch bottomView.getFocuseField() {
        case .pickup:
            bottomView.showClearPickup(show: true)
            bottomView.showClearDrop(show: false)
        case .drop:
            bottomView.showClearPickup(show: false)
            bottomView.showClearDrop(show: true)
        case .none:
            bottomView.showClearPickup(show: false)
            bottomView.showClearDrop(show: false)
        }
        
    }
    
    func openBottomView() {
        
        bottomView.showButtons(show: false)
        bottomView.transitionBottomView(state: .big)
        
        switch bottomView.getFocuseField() {
        case .pickup:
            bottomView.showTable(show: true)
        case .drop:
            bottomView.showTable(show: true)
        case .none: break
        }
        
    }
    
    func hideKeyboard() {

        if !keyboardHide {

            bottomView.endEditing(true)

            if routeLaid {
                bottomView.transitionBottomView(state: .medium)
            } else {
                bottomView.transitionBottomView(state: .small)
            }

            bottomView.showClearPickup(show: false)
            bottomView.showClearDrop(show: false)
            
            bottomView.showTable(show: false)
            bottomView.showButtons(show: routeLaid)

            keyboardHide = true

        }

    }
    
    func moveMyLocation() {
        
        if let coordinate = locationHandler.location?.coordinate {
            view?.setMapRegion(coordinate: coordinate)
        }
        
    }
    
    func regionDidChange() {
        
        if routeLaid {
            
            view?.showChangeAlert { answer in
                if answer {
                    self.deleteRout(causes: .changeRegion)
                } else {
                    self.view?.setRouteDefault()
                }
            }
            
        } else {
            
            getAddress()
            
        }
        
    }
    
    func getAddress() {
        
        if let location = view?.getMapLocation() {
            
            GeocoderHandler.getAddress(coordinate: location) { address in
                
                Network.getAddress(address: address) { suggestions in
                    
                    let suggestion = suggestions[0]
                    
                    self.pickup = Location(suggestion: suggestion, type: .Pickup, routeOrder: 1)
                    self.bottomView.setTextField(field: .pickup, text: suggestion.Name!)
                    self.bottomView.setSuggestions(suggestions: suggestions)
                    
                    self.setRoute()
                    
                }
                
            }
            
        }
        
    }
    
    func deleteRout(causes: Causes) {
        
        routeLaid = false
        
        delivery = nil
        pickup = nil
        drop = nil
        
        view?.deleteRout()
        view?.showPin(show: true)
        
        switch causes {
        case .selectField:
            switch bottomView.getFocuseField() {
            case .pickup:
                bottomView.setTextField(field: .drop, text: "")
                bottomView.setTextField(field: .pickup, text: "")
                bottomView.showClearPickup(show: true)
            case .drop:
                bottomView.setTextField(field: .drop, text: "")
            case .none:
                bottomView.setTextField(field: .drop, text: "")
                bottomView.setTextField(field: .pickup, text: "")
            }
        case .changeRegion:
            getAddress()
            bottomView.setTextField(field: .drop, text: "")
            bottomView.transitionBottomView(state: .small)
            bottomView.showButtons(show: false)
        }
        
        bottomView.activeOrderButton(active: false)
        
    }
    
    func pressClearPickupField() {
        bottomView.setTextField(field: .pickup, text: "")
    }
    
    func pressClearDropField() {
        bottomView.setTextField(field: .drop, text: "")
    }
    
    func pressMapDropField() {
        
        routeLaid = false
        
        if let location = drop {
            router?.openAddressMap(location: location)
        } else {
            drop = Location()
            if let coordinate = locationHandler.location?.coordinate { drop?.Point = Point(coordinate: coordinate) }
            router?.openAddressMap(location: drop!)
        }
        
        hideKeyboard()
        
    }
    
    func pressMyLocation() {
        
        if routeLaid {
            
            view?.showChangeAlert { answer in
                if answer {
                    self.moveMyLocation()
                    self.deleteRout(causes: .changeRegion)
                }
            }
            
        } else {
            
            if let coordinate = locationHandler.location?.coordinate {
                
                GeocoderHandler.getAddress(coordinate: coordinate) { address in
                    Network.getAddress(address: address) { suggestions in
                        
                        let suggestion = suggestions[0]
                        
                        self.pickup = Location(suggestion: suggestion, type: .Pickup, routeOrder: 1)
                        self.bottomView.setTextField(field: .pickup, text: suggestion.Name!)
                        
                    }
                }
                
                bottomView.setSuggestions(suggestions: [Dictionary.Suggestion]())
                moveMyLocation()
                
            }
            
        }
        
        hideKeyboard()
        
    }
    
    func textDidChange(text: String?) {
        
        if text == nil {
            bottomView.setSuggestions(suggestions: [Dictionary.Suggestion]())
        } else {
            Network.getAddress(address: text!) { suggestions in
                self.bottomView.setSuggestions(suggestions: suggestions)
            }
        }
        
    }
    
    func updateDrop() {
        
        if let point = drop?.Point?.Address {
            bottomView.setTextField(field: .drop, text: point)
            setRoute()
        }
        
    }
    
    func selectAddress(address: Dictionary.Suggestion) {
        
        if let name = address.Name {
            if let field = bottomView.getFocuseField() {
                bottomView.setTextField(field: field, text: name)
                bottomView.setFieldEdit(field: field)
            }
        }
        
        if address.ID != nil {
            
            switch bottomView.getFocuseField() {
            
            case .pickup:
                
                pickup = Location(suggestion: address, type: .Pickup, routeOrder: 1)
                bottomView.setFieldEdit(field: .drop)
                bottomView.showTable(show: true)
                
                if let point = address.Point {
                    view?.setMapRegion(coordinate: CLLocationCoordinate2D(latitude: point.Latitude!, longitude: point.Longitude!))
                }
                
                if let drop = drop {
                    
                    if address.ID != drop.ID {
                        hideKeyboard()
                        setRoute()
                        return
                    }
                    
                    view?.showWarning()
                    
                }
                
            case .drop:
                
                drop = Location(suggestion: address, type: .Drop, routeOrder: 2)

                if let pickup = pickup {
                    
                    if address.ID != pickup.ID {
                        hideKeyboard()
                        setRoute()
                        return
                    }
                    
                    view?.showWarning()
                    
                }
                
            case .none: break
                
            }
            
        }
        
        Network.getAddress(address: address.Name!) { suggestions in
            self.bottomView.setSuggestions(suggestions: suggestions)
        }
        
    }
    
    func setRoute() {
        
        guard let pickupPoint = pickup?.Point else { return }
        guard let dropPoint = drop?.Point else { return }
        
        if bottomView.getPickupText() == pickupPoint.Address && bottomView.getDropText() == dropPoint.Address {
            view?.showPin(show: false)
            view!.setRoute(pickup: pickupPoint, drop: dropPoint)
        }
        
    }
    
    func didRouteLaid() {
        
        routeLaid = true
        
        guard let pickup = pickup else { return }
        guard let drop = drop else { return }
        
        var types = [Delivery]()
        
        Network.calculateDelivery(locations: [pickup.getString(), drop.getString()], type: .Walk) { delivery in
            types.append(delivery)
            self.updatePrices(types: types)
        }
        
        Network.calculateDelivery(locations: [pickup.getString(), drop.getString()], type: .Car) { delivery in
            types.append(delivery)
            self.updatePrices(types: types)
        }
        
    }
    
    func updatePrices(types: [Delivery]) {
        self.bottomView.reloadCollection(types: types)
        self.bottomView.showButtons(show: true)
        self.bottomView.transitionBottomView(state: .medium)
    }
    
    func selectDelivery(delivery: Delivery) {
        self.delivery = delivery
        self.bottomView.activeOrderButton(active: true)
    }
    
    func openNewOrder() {
        if let order = delivery { router?.openNewOrder(model: order) }
    }
    
    func openSideMenu() {
        router?.openSideMenu()
    }
    
    func openMarketplaces() {
        router?.openMarketplace()
    }
    
}
