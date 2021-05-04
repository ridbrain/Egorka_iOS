//
//  DetailsProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 23.03.2021.
//

import UIKit

protocol DetailsViewProtocol: UIViewController {
    
    var presenter: DetailsPresenterProtocol? { get set }
    
    func setVisibleDateView(state: Int)
    func setLabels(address: String, contacts: String)
    func setNum(color: UIColor, label: String)
    func getLabel() -> String
    func setAddress(text: String)
    func setEntrance(text: String)
    func setFloor(text: String)
    func setRoom(text: String)
    func setName(text: String)
    func setPhone(text: String)
    func setMessage(text: String)
    func setDate(text: String)
    func setTime(text: String)
    func setDateDelegate()
    func getPickerDate() -> Date
    func getPickerTime() -> Date
    func getName() -> String?
    func getPhone() -> String?
    func getEntrance() -> String?
    func getFloor() -> String?
    func getRoom() -> String?
    func getMessage() -> String?
    func getSwitchState() -> Bool
    func setPickerDate(date: Date, time: Date)
    func setDelete()
    
}

protocol DetailsPresenterProtocol: AnyObject {
    
    init(router: GeneralRouterProtocol, model: Location, view: DetailsViewProtocol, index: Int)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func setQuickly(quickly: Bool)
    func pressAddress()
    func textDidChange(text: String?)
    func selectAddress(address: Dictionary.Suggestion)
    func deleteAddress()
    
}
