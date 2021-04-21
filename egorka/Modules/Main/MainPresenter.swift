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
    var model: MainModeleProtocol?
    
    var location: LocationHandeler!
    var bottomView: MainBottomViewProtocol!

    var myLocation = false
    var routeLaid = false
    var keyboardHide = true
    
    required init(router: GeneralRouterProtocol, model: MainModeleProtocol, view: MainViewProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func viewDidLoad() {
        
        view?.setMapDelegate()
        
        location = LocationHandeler() { location in
            
            if !(self.myLocation) {
                self.view?.setMapRegion(coordinate: location.coordinate)
                self.myLocation = true
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
            
            bottomView.showTable(show: false, extra: 0)
            bottomView.showButtons(show: routeLaid)
            
        } else {
            
            deleteRout(causes: .changeRegion)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.moveMyLocation()
            }
            
        }
        
        bottomView.reloadCollection()
        
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
            bottomView.changeIconPickupField(edit: true)
            bottomView.showIconDropField(show: false)
        case .drop:
            bottomView.changeIconPickupField(edit: false)
            bottomView.showIconDropField(show: true)
        case .none:
            bottomView.changeIconPickupField(edit: false)
            bottomView.showIconDropField(show: false)
        }
        
    }
    
    func openBottomView() {
        
        bottomView.showButtons(show: false)
        bottomView.transitionBottomView(state: .big)
        
        switch bottomView.getFocuseField() {
        case .pickup:
            bottomView.showWhere(show: false)
            bottomView.showTable(show: true, extra: 60)
        case .drop:
            bottomView.showWhere(show: true)
            bottomView.showTable(show: true, extra: 120)
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

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.bottomView.changeIconPickupField(edit: false)
                self.bottomView.showIconDropField(show: false)
            }
            
            bottomView.showTable(show: false, extra: 0)
            bottomView.showWhere(show: true)
            bottomView.showButtons(show: routeLaid)

            keyboardHide = true

        }

    }
    
    func moveMyLocation() {
        
        if let coordinate = location.locations?[0].coordinate {
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
                    
                    self.model!.pickups = [NewOrderLocation(suggestion: suggestions[0], type: .Pickup, routeOrder: 1)]
                    self.bottomView.setTextField(field: .pickup, text: suggestions[0].Name!)
                    self.bottomView.setSuggestions(suggestions: suggestions)
                    
                }
                
            }
            
        }
        
    }
    
    func deleteRout(causes: Causes) {
        
        routeLaid = false
        
        view?.deleteRout()
        view?.showPin(show: true)
        
        switch causes {
        case .selectField:
            switch bottomView.getFocuseField() {
            case .pickup:
                bottomView.setTextField(field: .drop, text: "")
                bottomView.setTextField(field: .pickup, text: "")
                bottomView.changeIconPickupField(edit: true)
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
        
        
    }
    
    func pressPickupFieldButton() {
        
        if bottomView.getFocuseField() == .pickup && !keyboardHide {
            bottomView.setTextField(field: .pickup, text: "")
            bottomView.changeIconPickupField(edit: true)
        } else {
            pressMyLocation()
        }
        
    }
    
    func pressDropFieldButton() {
        
        if bottomView.getFocuseField() == .drop && !keyboardHide {
            bottomView.setTextField(field: .drop, text: "")
        }
        
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
            
            if let coordinate = location.locations?[0].coordinate {
                
                GeocoderHandler.getAddress(coordinate: coordinate) { address in
                    Network.getAddress(address: address) { addresses in
                        self.model!.pickups = [NewOrderLocation(suggestion: addresses[0], type: .Pickup, routeOrder: 1)]
                        self.bottomView.setTextField(field: .pickup, text: addresses[0].Name!)
                    }
                }
                
                bottomView.setSuggestions(suggestions: [Suggestion]())
                moveMyLocation()
                
            }
            
        }
        
        hideKeyboard()
        
    }
    
    func textDidChange(text: String?) {
        
        if text == nil {
            bottomView.setSuggestions(suggestions: [Suggestion]())
        } else {
            Network.getAddress(address: text!) { suggestions in
                self.bottomView.setSuggestions(suggestions: suggestions)
            }
        }
        
    }
    
    func selectAddress(address: Suggestion) {
        
        if let name = address.Name {
            if let field = bottomView.getFocuseField() {
                bottomView.setTextField(field: field, text: name)
                bottomView.setFieldEdit(field: field)
            }
        }
        
        if address.ID != nil {
            
            switch bottomView.getFocuseField() {
            
            case .pickup:
                
                model!.pickups = [NewOrderLocation(suggestion: address, type: .Pickup, routeOrder: 1)]
                bottomView.setFieldEdit(field: .drop)
                bottomView.showWhere(show: true)
                bottomView.showTable(show: true, extra: 120)
                
                if let point = address.Point {
                    view?.setMapRegion(coordinate: CLLocationCoordinate2D(latitude: point.Latitude!, longitude: point.Longitude!))
                }
                
                if let drop = model?.drops?.first {
                    
                    if address.ID != drop.ID {
                        hideKeyboard()
                        setRoute()
                        return
                    }
                    
                    view?.showWarning()
                    
                }
                
            case .drop:
                
                model!.drops = [NewOrderLocation(suggestion: address, type: .Drop, routeOrder: 2)]

                if let pickup = model?.pickups?.first {
                    
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
        
        if model!.pickups!.count > 0 && model!.drops!.count > 0 {
            if bottomView.getTextFromField()[0] == model?.pickups![0].Point?.Address
                && bottomView.getTextFromField()[1] == model?.drops![0].Point?.Address {
                view?.showPin(show: false)
                view!.setRoute(pickup: model!.pickups![0].Point!, drop: model!.drops![0].Point!)
            }
        }
        
    }
    
    func didRouteLaid() {
        
        routeLaid = true
        
        bottomView.reloadCollection()
        bottomView.showButtons(show: true)
        bottomView.transitionBottomView(state: .medium)
        
    }
    
    func openNewOrder() {
        
        router?.openNewOrder(model: model!)
        
    }
    
    func openSideMenu() {
        
        router?.openSideMenu()
        
    }
    
}
