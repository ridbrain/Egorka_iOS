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
    var mapRect: MKMapRect?
    var notify: Bool = true
    let padding = UIEdgeInsets(top: CGFloat(100), left: CGFloat(80), bottom: CGFloat(250), right: CGFloat(80))
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        self.mapView = mapView
        self.location = mapView.centerCoordinate
        
        if notify {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "regionDidChangeAnimated"), object: nil)
        }
        
        notify = true
        
    }
    
    func getRoute(from: Address, where: Address) {
        
        let first = CLLocationCoordinate2D(latitude: from.Point!.Latitude!, longitude: from.Point!.Longitude!)
        let secondCLL = CLLocationCoordinate2D(latitude: `where`.Point!.Latitude!, longitude: `where`.Point!.Longitude!)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: first, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: secondCLL, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = from.Name
        
        if let location = sourcePlacemark.location {
          sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = `where`.Name
        
        if let location = destinationPlacemark.location {
          destinationAnnotation.coordinate = location.coordinate
        }
        
        if let mapView = mapView {
            
            mapView.addAnnotation(sourceAnnotation)
            mapView.addAnnotation(destinationAnnotation)
            
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
                
                self.mapRect = route.polyline.boundingMapRect
                self.setMapRect()
                
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.colorAccentTransparent
        renderer.lineWidth = 4.0
        
        return renderer
        
    }
    
    func setMapRect() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didRouteLaid"), object: nil)
        
        notify = false
        mapView!.setVisibleMapRect(mapRect!, edgePadding: padding, animated: true)
        
    }
    
}
