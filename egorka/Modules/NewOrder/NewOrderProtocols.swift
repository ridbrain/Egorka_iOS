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
    func updateTables(pickups: [NewOrderLocation], drops: [NewOrderLocation], numState: NumState) 
    func showWarning()
    
}

protocol NewOrderPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, model: MainModeleProtocol, view: NewOrderViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    
    func openDetails(location: NewOrderLocation, index: Int)
    func deleteLocation(type: LocationType, index: Int) 
    func newPickup()
    func newDrop()
    func cancel()
    
}
