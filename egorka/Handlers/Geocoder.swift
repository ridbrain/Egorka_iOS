//
//  Geocoder.swift
//  egorka
//
//  Created by Виталий Яковлев on 11.12.2020.
//

import Foundation
import MapKit

class MyGeocoder {
    
    class func getAddress(coordinate: CLLocationCoordinate2D, complition: @escaping (String) -> Void ) {
        
        let cll = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(cll) { (placemarks, error) in
            
            if let _ = error {
                complition("Не точный адрес")
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                
                if streetNumber == "" {
                    complition("\(streetName)")
                } else {
                    complition("\(streetName), \(streetNumber)")
                }
                
            }
            
        }
        
    }
    
}
