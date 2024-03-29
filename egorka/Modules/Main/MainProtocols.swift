//
//  MainProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 21.03.2021.
//

import UIKit
import MapKit

protocol MainViewProtocol: UIViewController {
    
    var presenter: MainPresenterProtocol? { get set }
    
    func hideNavBar()
    func setMapDelegate()
    func setMapRegion(coordinate: CLLocationCoordinate2D)
    func deleteRout()
    func showPin(show: Bool)
    func showChangeAlert(answer: @escaping (Bool) -> Void)
    func setRoute(pickup: Point, drop: Point)
    func setRouteDefault()
    func getMapLocation() -> CLLocationCoordinate2D?
    func showWarning()
    
}

protocol MainPresenterProtocol: AnyObject {
    
    init(router: GeneralRouterProtocol, view: MainViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func hideKeyboard()
    func textDidChange(text: String?)
    func regionDidChange()
    func didRouteLaid()
    func selectAddress(address: Dictionary.Suggestion)
    func openNewOrder()
    func openSideMenu()
    func openMarketplaces()
    func selectDelivery(delivery: Delivery)
    func pressMyLocation()
    func pressClearPickupField()
    func pressClearDropField()
    func pressMapDropField()
    
}
