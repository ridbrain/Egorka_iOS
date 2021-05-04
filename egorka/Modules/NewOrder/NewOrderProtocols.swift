//
//  NewOrderProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 22.03.2021.
//

import UIKit

protocol NewOrderViewProtocol: UIViewController {
    
    var presenter: NewOrderPresenterProtocol? { get set }
    
    func setTitle(title: String)
    func setTableViews()
    func updateTables(pickups: [Location], drops: [Location], numState: NumState) 
    func showWarning()
    
}

protocol NewOrderPresenterProtocol: AnyObject {
    
    init(router: GeneralRouterProtocol, model: Delivery, view: NewOrderViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    
    func openDetails(location: Location, index: Int)
    func deleteLocation(routeOrder: Int) 
    func newPickup()
    func newDrop()
    func cancel()
    
}
