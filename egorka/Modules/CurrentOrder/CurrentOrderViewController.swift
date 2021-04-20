//
//  CurrentOrderViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 25.03.2021.
//

import UIKit
import MapKit

class CurrentOrderViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    private var tableDelegate: LocationTableView!
    private var mapDelegate: MKMapDelegate!
    private var mapPadding = UIEdgeInsets(top: CGFloat(30), left: CGFloat(30), bottom: CGFloat(30), right: CGFloat(30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Текущий заказ"
        
        phoneButton.layer.cornerRadius = phoneButton.frame.height / 2
        chatButton.layer.cornerRadius = chatButton.frame.height / 2
        typeView.layer.cornerRadius = typeView.frame.height / 2
        photoView.layer.cornerRadius = photoView.frame.height / 2

        mapDelegate = MKMapDelegate() { regionDidChange in }
        
        mapView.layer.cornerRadius = 15
        mapView.layer.borderWidth = 2
        mapView.layer.borderColor = UIColor.white.cgColor
        mapView.delegate = mapDelegate
        
        let pickup = Point()
        pickup.Latitude = 55.622868
        pickup.Longitude = 37.666306
        pickup.Address = "A1"
        let drop = Point()
        drop.Latitude = 55.637987
        drop.Longitude = 37.761285
        drop.Address = "B1"
        
        mapDelegate.getRoute(pickup: pickup, drop: drop) { polyline in
            
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.title = pickup.Address
            sourceAnnotation.coordinate = CLLocationCoordinate2D(latitude: pickup.Latitude!, longitude: pickup.Longitude!)
            
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = drop.Address
            destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: drop.Latitude!, longitude: drop.Longitude!)
            
            self.mapView.addAnnotation(sourceAnnotation)
            self.mapView.addAnnotation(destinationAnnotation)
            self.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
            self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: self.mapPadding, animated: true)
            
        }
        
        var locations = [NewOrderLocation]()
        
        locations.append(NewOrderLocation(suggestion: Suggestion(ID: "1", Name: "Cолнечная", Point: pickup), type: .Pickup, routeOrder: 1))
        locations.append(NewOrderLocation(suggestion: Suggestion(ID: "2", Name: "Паромная", Point: drop), type: .Drop, routeOrder: 2))
        
        setTableViews()
        updateTables(locations: locations)
        
        
    }
    
    func setTableViews() {
        
        tableDelegate = LocationTableView(didSelectRow: nil, deleteRow: nil)
        
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
        tableView.register(LocationTableViewCell.nib, forCellReuseIdentifier: LocationTableViewCell.reuseID)
        
    }
    
    func updateTables(locations: [NewOrderLocation]) {
        
        tableDelegate.locations = locations
        tableHeight.constant = CGFloat(95 * locations.count)
        tableView.reloadData()
        
    }

}
