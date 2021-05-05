//
//  MapViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 05.05.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewProtocol {
    
    var presenter: MapPresenterProtocol?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Маркетплейсы"
        
        mapView.delegate = self
        presenter?.viewDidLoad()
        
    }
    
    func setPoints(loactions: [Location]) {
        
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

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let custom = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        custom.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        custom.canShowCallout = true
        custom.image = UIImage(named: "Pin.png")
        
        return custom
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let coordinate = view.annotation?.coordinate {
            
            let location = CLLocationCoordinate2D(
                latitude: CLLocationDegrees(coordinate.latitude),
                longitude: CLLocationDegrees(coordinate.longitude))
            
            let region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: 20000,
                longitudinalMeters: 20000)
            
            mapView.setRegion(region, animated: true)
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let point = view.annotation as? LocationPoint {
            presenter?.setLocation(location: point.location)
        }

    }
    
}
