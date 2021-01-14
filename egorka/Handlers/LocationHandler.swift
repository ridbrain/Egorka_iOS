//
//  LocationHandler.swift
//  egorka
//
//  Created by Виталий Яковлев on 10.12.2020.
//

import CoreLocation

class LocationHandeler: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var locations: [CLLocation]?
    
    let manager: CLLocationManager = {
        
        let locationManager = CLLocationManager()

        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 10
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .fitness
        locationManager.showsBackgroundLocationIndicator = true
        
        return locationManager
        
    }()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
          locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
          locationManager.requestLocation()
        }
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        if status == .authorizedWhenInUse {
            manager.requestAlwaysAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations = locations
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didUpdateLocations"), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let locationError = error as? CLError else {
            print(error)
            return
        }
        NSLog(locationError.localizedDescription)
    }
    
}