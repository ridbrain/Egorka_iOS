//
//  AddressMapViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 16.05.2021.
//

import UIKit
import MapKit

class AddressMapViewController: UIViewController, AddressMapViewProtocol {
    
    var presenter: AddressMapPresenterProtocol?
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var mapDelegate: MKMapDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        mapDelegate = MKMapDelegate() { self.presenter?.setLocation(coordinate: $0) }
        mapView.delegate = mapDelegate
        
    }
    
    func setTitle(title: String) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = title
    }
    
    func setCoordinate(with coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }

}
