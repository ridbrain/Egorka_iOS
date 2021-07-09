//
//  MapProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 05.05.2021.
//

import UIKit

protocol MarketMapViewProtocol: UIViewController {
    
    var presenter: MarketMapPresenterProtocol? { get set }
    
    func setPoints(title: String, loactions: [Location])
    
}

protocol MarketMapPresenterProtocol: AnyObject {
    
    init(view: MarketMapViewProtocol, location: Location, locations: [Location])
    
    func viewDidLoad()
    func setLocation(location: Location)
    
}
