//
//  MarketMapDelegate.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 13.05.2021.
//

import UIKit
import MapKit

class MarketMapDelegate: NSObject, MKMapViewDelegate {
    
    var selectLocation: (Location) -> Void
    
    required init(selectLocation: @escaping (Location) -> Void) {
        self.selectLocation = selectLocation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let custom = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        custom.canShowCallout = true
        custom.image = .pinDefault
        
        if let pin = annotation as? LocationPoint {
            
            if let name = pin.location.Point?.Name {
                
                if let brend = name.components(separatedBy: " ").first?.lowercased().dropLast() {
                    
                    switch brend {
                    case "egorka":
                        custom.image = .pinEgorka
                    case "ozon":
                        custom.image = .pinOzon
                    case "wildberries":
                        custom.image = .pinWildberries
                    case "пэк":
                        custom.image = .pinPek
                    case "сберлогистика":
                        custom.image = .pinSber
                    case "яндекс.маркет":
                        custom.image = .pinYandex
                    default:
                        custom.image = .pinDefault
                    }
                    
                }
                
            }
             
        }
        
        return custom
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let point = view.annotation as? LocationPoint {
            
            selectLocation(point.location)
            
            let location = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(point.coordinate.latitude),
                longitude: CLLocationDegrees(point.coordinate.longitude))
            
            let region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: 15000,
                longitudinalMeters: 15000)
            
            mapView.setRegion(region, animated: true)
            
        }
        
    }
    
}
