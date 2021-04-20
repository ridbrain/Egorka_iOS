//
//  MKMapDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 11.12.2020.
//

import Foundation
import MapKit

class MKMapDelegate: NSObject, MKMapViewDelegate {
    
    var regionDidChange: (CLLocationCoordinate2D) -> Void
    
    required init(regionDidChange: @escaping (CLLocationCoordinate2D) -> Void) {
        self.regionDidChange = regionDidChange
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        regionDidChange(mapView.centerCoordinate)
    }
    
    func getRoute(pickup: Point, drop: Point, complition: @escaping (MKPolyline) -> Void) {
        
        let pickup = CLLocationCoordinate2D(latitude: pickup.Latitude!, longitude: pickup.Longitude!)
        let drop = CLLocationCoordinate2D(latitude: drop.Latitude!, longitude: drop.Longitude!)
        
        let sourcePlacemark = MKPlacemark(coordinate: pickup, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: drop, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { response, error in
            
            if let response = response {
                complition(response.routes[0].polyline)
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.colorGreen
        renderer.lineWidth = 4.0
        
        return renderer
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "MyPin")
        annotationView.canShowCallout = true
        
        if let myPoint = annotation as? MyPoint {
            
            switch myPoint.type {
            case .Pickup:
                annotationView.image = UIImage(named: "PinA.png")
            case .Drop:
                annotationView.image = UIImage(named: "PinB.png")
            }
            
        }
        
        return annotationView
        
    }
    
}
