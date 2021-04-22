//
//  CurentOrderProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 22.04.2021.
//

import UIKit

protocol CurrentOrderViewProtocol: UIViewController {
    
    var presenter: CurrentOrderPresenterProtocol? { get set }
    
    func setRoute(pickup: Point, drop: Point)
    func updateTables(locations: [Location])
    
}

protocol CurrentOrderPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, view: CurrentOrderViewProtocol)
    
    func viewDidLoad()
    
}
