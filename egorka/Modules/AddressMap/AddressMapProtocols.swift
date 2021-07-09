//
//  AddressMapProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 16.05.2021.
//

import UIKit
import MapKit

protocol AddressMapViewProtocol: UIViewController {
    
    var presenter: AddressMapPresenterProtocol? { get set }
    
    func setTitle(title: String)
    func setCoordinate(with coordinate: CLLocationCoordinate2D) 
    
}

protocol AddressMapPresenterProtocol: AnyObject {
    
    init(view: AddressMapViewProtocol, location: Location)
    
    func viewDidLoad()
    func setLocation(coordinate: CLLocationCoordinate2D)
    
}

