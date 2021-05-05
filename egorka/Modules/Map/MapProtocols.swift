//
//  MapProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 05.05.2021.
//

import UIKit

protocol MapViewProtocol: UIViewController {
    
    var presenter: MapPresenterProtocol? { get set }
    
    func setPoints(loactions: [Location])
    
}

protocol MapPresenterProtocol: AnyObject {
    
    init(view: MapViewProtocol, location: Location, locations: [Location])
    
    func viewDidLoad()
    func setLocation(location: Location)
    
}
