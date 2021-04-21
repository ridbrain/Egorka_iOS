//
//  DetailsPresenter.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 16.03.2021.
//

import UIKit

class DetailsPresenter: DetailsPresenterProtocol {
    
    weak var view: DetailsViewProtocol?
    var model: NewOrderLocation?
    var router: GeneralRouterProtocol?
    var bottomView: AddressBottomViewProtocol!
    
    var selfView = true
    var defaultDate: Int!
    var index: Int!
    
    required init(router: GeneralRouterProtocol, model: NewOrderLocation, view: DetailsViewProtocol, index: Int) {
        self.router = router
        self.model = model
        self.view = view
        self.index = index
    }
    
    func viewDidLoad() {
        
        bottomView = AddressBottomSheet()
        bottomView.presenter = self
        bottomView.setTextDelegate()
        bottomView.initTableView()
        
        loadDetails()
        
        if model?.Point?.Code == nil {
            DispatchQueue.global(qos: .background).async {
                sleep(1)
                DispatchQueue.main.async { [self] in
                    if selfView {
                        pressAddress()
                    }
                }
            }
        }
        
    }
    
    func viewWillAppear() {
        
        setNotificationCenter()
        view?.enableIQKeyboard()
        
    }
    
    func viewWillDisappear() {
        
        selfView = false
        
        saveDetails()
        removeNotificationCenter()
        view?.disableIQKeyboard()
        
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
            bottomView.setTableHeight(height: keyboardFrame.cgRectValue.height)
        }
        
    }
    
    func loadDetails() {
        
        if model?.Type == LocationType.Pickup {
            
            view?.setLabels(address: "Откуда забрать?", contacts: "Контакты отправителя")
            view?.setNum(color: .colorAccent, label: "A\(index+1)")
            
            if index == 0 {
                
                if model?.Date == nil {
                    
                    view?.setVisibleDateView(state: 1)
                    
                } else {
                    
                    view?.setVisibleDateView(state: 2)
                    setDate()
                    
                }
                
            } else {
                
                view?.setVisibleDateView(state: 0)
                
            }
            
        } else {
            
            view?.setLabels(address: "Куда отвезти?", contacts: "Контакты получателя")
            view?.setNum(color: .colorBlue, label: "B\(index+1)")
            view?.setVisibleDateView(state: 0)
            
        }
        
        if let address = model?.Point?.Address { view?.setAddress(text: address) }
        if let entrance = model?.Point?.Entrance { view?.setEntrance(text: String(entrance)) }
        if let floor = model?.Point?.Floor { view?.setFloor(text: String(floor)) }
        if let room = model?.Point?.Room { view?.setRoom(text: String(room)) }
        if let name = model?.Contact?.Name { view?.setName(text: name) }
        if let phone = model?.Contact?.PhoneMobile { view?.setPhone(text: phone) }
        if let message = model?.Message { view?.setMessage(text: message) }
        if index != 0 { view?.setDelete() }
        
        setupDatePicker()
        
    }
    
    func setDate() {
        
        if let date = DateFormatter().fromISO(date: model!.Date!) {
            
            view?.setDate(text: DateFormatter().gmt3().dayMonthYear(date: date))
            view?.setTime(text: DateFormatter().gmt3().hoursMins(date: date))
            view?.setPickerDate(date: date, time: date)
            
        }
        
    }
    
    func setupDatePicker() {
        
        defaultDate = Int(NSDate().timeIntervalSince1970)
        view?.setDateDelegate()
        
    }
    
    func setQuickly(quickly: Bool) {
        
        if quickly {
            
            view?.setVisibleDateView(state: 1)
            
        } else {
            
            view?.setVisibleDateView(state: 2)
            view?.setDate(text: DateFormatter().gmt3().dayMonthYear(date: view!.getPickerDate()))
            view?.setTime(text: DateFormatter().gmt3().hoursMins(date: view!.getPickerTime()))
            
        }
        
        view?.view.endEditing(true)
        
    }
    
    func saveDetails() {
        
        let contact = Contact()
        
        if let name = view?.getName() {
            if name.count > 1 {
                contact.Name = name
            } else {
                contact.Name = nil
            }
        }
        
        if let phone = view?.getPhone() {
            if phone.count == 18 {
                contact.PhoneMobile = phone
            } else {
                contact.PhoneMobile = nil
            }
        }
        
        if contact.Name != nil || contact.PhoneMobile != nil {
            model?.Contact = contact
        } else {
            model?.Contact = nil
        }
        
        if let entrance = Int(view?.getEntrance() ?? "") {
            if entrance != 0 {
                model?.Point?.Entrance = entrance
            } else {
                model?.Point?.Entrance = nil
            }
        } else {
            model?.Point?.Entrance = nil
        }
        
        if let floor = Int(view?.getFloor() ?? "") {
            if floor != 0 {
                model?.Point?.Floor = floor
            } else {
                model?.Point?.Floor = nil
            }
        } else {
            model?.Point?.Floor = nil
        }
        
        if let room = Int(view?.getRoom() ?? "") {
            if room != 0 {
                model?.Point?.Room = room
            } else {
                model?.Point?.Room = nil
            }
        } else {
            model?.Point?.Room = nil
        }
        
        if model?.RouteOrder == 1 && view?.getSwitchState() == false {
            if defaultDate < Int(view!.getPickerTime().timeIntervalSince1970) {
                model?.Date = DateFormatter().gmt3().iso(date: view!.getPickerTime())
            }
        } else {
            model?.Date = nil
        }
        
        if let message = view?.getMessage() {
            if message.count > 0 {
                model?.Message = message
            } else {
                model?.Message = nil
            }
        }
        
    }
    
    func pressAddress() {
        
        view?.disableIQKeyboard()
        bottomView.presentBottomView(view: view!.view!, text: view!.getLabel())
        
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
        
        bottomView.setAddressText(text: address.Name!)
        
        if address.ID != nil {
            
            model?.Point = address.Point
            model?.Point?.Code = address.ID
            model?.Point?.Address = address.Name
            
            view?.setAddress(text: address.Name!)
            bottomView.dismiss()
            
        } else {
            
            Network.getAddress(address: address.Name!) { suggestions in
                self.bottomView.setSuggestions(suggestions: suggestions)
            }
            
        }
        
    }
    
    func deleteAddress() {
        
        model?.Point = Point()
        view?.navigationController?.popViewController(animated: true)
        
    }
    
    func pressClearAddress() {
        bottomView.setAddressText(text: "")
    }

}
