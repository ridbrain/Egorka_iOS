//
//  MainViewController.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainPresenterProtocol?
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var marketplaces: UIButton!
    
    private var mapPadding = UIEdgeInsets(top: CGFloat(100), left: CGFloat(80), bottom: CGFloat(320), right: CGFloat(80))
    private var mapDelegate: MKMapDelegate!
    private var mapCoordinate: CLLocationCoordinate2D?
    private var mapRect: MKMapRect?
    private var mapNotify: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketplaces.clipsToBounds = true
        marketplaces.layer.cornerRadius = marketplaces.frame.height / 2
        marketplaces.alpha = 0
        
        presenter?.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.marketplaces.alpha = 0.9
        })
        
        presenter?.viewWillAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.first != nil {
            presenter?.hideKeyboard()
        }
    }
    
    func hideNavBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setMapDelegate() {
        
        mapNotify = true
        
        mapDelegate = MKMapDelegate() { coordinate in
            
            self.mapCoordinate = coordinate
            
            if self.mapNotify {
                self.presenter?.regionDidChange()
            }
            
            self.mapNotify = true
            
        }
        
        mapView.delegate = mapDelegate
        
    }
    
    func setMapRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func deleteRout() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func showPin(show: Bool) {
        pinImage.isHidden = !show
    }
    
    func setRoute(pickup: Point, drop: Point) {
        
        mapDelegate.getRoute(pickup: pickup, drop: drop) { polyline in
            
            let sourceAnnotation = MyPoint(type: .Pickup)
            sourceAnnotation.title = pickup.Address
            sourceAnnotation.coordinate = CLLocationCoordinate2D(latitude: pickup.Latitude!, longitude: pickup.Longitude!)
            
            let destinationAnnotation = MyPoint(type: .Drop)
            destinationAnnotation.title = drop.Address
            destinationAnnotation.coordinate = CLLocationCoordinate2D(latitude: drop.Latitude!, longitude: drop.Longitude!)
            
            self.mapNotify = false
            self.mapRect = polyline.boundingMapRect
            
            self.mapView.addAnnotation(sourceAnnotation)
            self.mapView.addAnnotation(destinationAnnotation)
            self.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
            self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: self.mapPadding, animated: true)
            
            self.presenter?.didRouteLaid()
            
        }
        
    }
    
    func setRouteDefault() {
        
        if let mapRect = mapRect {
            
            mapNotify = false
            mapView.setVisibleMapRect(mapRect, edgePadding: mapPadding, animated: true)
            
        }
    
    }
    
    func getMapLocation() -> CLLocationCoordinate2D? {
        return mapCoordinate
    }
    
    @IBAction func pressMenu(_ sender: Any) {
        presenter?.openSideMenu()
    }
    
    @IBAction func pressMarketplaces(_ sender: Any) {
        presenter?.openMarketplaces()
    }
    
    func showChangeAlert(answer: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "Хотите изменить маршрут доставки?", message:  nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction( title: "Нет", style: .default, handler: { alert in answer(false) }))
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { alert  in answer(true) }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showWarning() {
        
        let alert = UIAlertController(title: "Внимание", message:  "Вы указали два одинаковых адреса, построение маршрута невозможно.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Понятно", style: .default, handler: { _ in }))

        present(alert, animated: true, completion: nil)
        
    }

}
