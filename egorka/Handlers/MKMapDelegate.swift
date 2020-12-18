//
//  MKMapDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 11.12.2020.
//

import Foundation
import MapKit

class MKMapDelegate: NSObject, MKMapViewDelegate {
    
    var mapView: MKMapView?
    var location: CLLocationCoordinate2D?
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        self.mapView = mapView
        self.location = mapView.centerCoordinate
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "regionDidChangeAnimated"), object: nil)
        
    }
    
    func getRoute(from: CLLocationCoordinate2D, where: CLLocationCoordinate2D) {
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: from, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: `where`, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Откуда"
        
        if let location = sourcePlacemark.location {
          sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Куда"
        
        if let location = destinationPlacemark.location {
          destinationAnnotation.coordinate = location.coordinate
        }
        
        if let mapView = mapView {
            
            mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
            
            // 7.
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            
            // Calculate the direction
            let directions = MKDirections(request: directionRequest)
            
            // 8.
            directions.calculate { response, error in
                
                guard let response = response else { return }
                
                let route = response.routes[0]
                mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                let padding = UIEdgeInsets(top: CGFloat(100), left: CGFloat(100), bottom: CGFloat(300), right: CGFloat(100))

                mapView.setVisibleMapRect(rect, edgePadding: padding, animated: true)
                
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.colorAccent
        renderer.lineWidth = 4.0
        
        return renderer
        
    }
    
}
