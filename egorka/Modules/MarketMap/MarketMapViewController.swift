//
//  MapViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 05.05.2021.
//

import UIKit
import MapKit

class MarketMapViewController: UIViewController, MarketMapViewProtocol {
    
    var presenter: MarketMapPresenterProtocol?
    var marketDelegate: MarketMapDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func setPoints(title: String, loactions: [Location]) {
        
        navigationItem.title = title
        
        marketDelegate = MarketMapDelegate() { self.presenter?.setLocation(location: $0) }
        mapView.delegate = marketDelegate
        
        let mapEdgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        var zoomRect = MKMapRect.null
        
        loactions.forEach { location in
            
            let pin = LocationPoint(location: location)
            let point = MKMapPoint(pin.coordinate)
            let rect = MKMapRect(x: point.x, y: point.y, width: 0.1, height: 0.1)
            
            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
            
            mapView.addAnnotation(pin)
            
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
        }
        
    }

}
