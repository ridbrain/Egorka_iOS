//
//  CurrentOrderViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 25.03.2021.
//

import UIKit
import MapKit

class CurrentOrderViewController: UIViewController, CurrentOrderViewProtocol {
    
    var presenter: CurrentOrderPresenterProtocol?

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

        mapDelegate = MKMapDelegate() { _ in }
        
        mapView.layer.cornerRadius = 15
        mapView.layer.borderWidth = 2
        mapView.layer.borderColor = UIColor.white.cgColor
        mapView.delegate = mapDelegate
        
        tableDelegate = LocationTableView(didSelectRow: nil, deleteRow: nil)
        
        tableView.setCorner()
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
        tableView.register(LocationTableViewCell.nib, forCellReuseIdentifier: LocationTableViewCell.reuseID)
        
        presenter?.viewDidLoad()
        
    }
    
    func setRoute(pickup: Point, drop: Point) {
        
        mapDelegate.getRoute(pickup: pickup, drop: drop) { polyline in
            
            let sourceAnnotation = MyPoint(type: .Pickup)
            sourceAnnotation.title = pickup.Address
            sourceAnnotation.coordinate = CLLocationCoordinate2D(latitude: pickup.Latitude!, longitude: pickup.Longitude!)
            
            let destinationAnnotation = MyPoint(type: .Drop)
            destinationAnnotation.title = drop.Address
            destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: drop.Latitude!, longitude: drop.Longitude!)
            
            self.mapView.addAnnotation(sourceAnnotation)
            self.mapView.addAnnotation(destinationAnnotation)
            self.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
            self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: self.mapPadding, animated: true)
            
        }
        
    }

    
    func updateTables(locations: [NewOrderLocation]) {
        
        tableDelegate.locations = locations
        tableHeight.constant = CGFloat(95 * locations.count)
        tableView.reloadData()
        
    }

}
