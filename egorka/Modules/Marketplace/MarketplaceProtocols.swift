//
//  MarketplaceProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 03.05.2021.
//

import UIKit

protocol MarketplaceViewProtocol: UIViewController {
    
    var presenter: MarketplacePresenterProtocol? { get set }
    
    func setTitle(title: String)
    func setPickup(text: String)
    func setDrop(text: String)
    func setPlacesDelegate(locations: [Marketplaces.Point])
    
}

protocol MarketplacePresenterProtocol: AnyObject {
    
    init(router: GeneralRouterProtocol, view: MarketplaceViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func pressAddress()
    func selectDropPlace(place: Marketplaces.Point)
    func pressMyLocation()
    func pressMarketMap()
    
}
