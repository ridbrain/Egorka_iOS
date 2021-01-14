//
//  MainPresenter.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import MapKit
import FINNBottomSheet

protocol MainViewProtocol: UIViewController {
    
    var presenter: MainPresenterProtocol? { get set }
    var mapView: MKMapView! { get set }
    var pinImage: UIImageView! { get set }
    var logo: UIImageView! { get set }
    
}

protocol MainBottomViewProtocol: UIView {
    
    var contetntHeight: [CGFloat]! { get set }
    var keyboardHeight: CGFloat? { get set }
    var fromField: UITextField! { get set }
    var whereField: UITextField! { get set }
    var tableView: UITableView! { get set }
    
    func showTable(show: Bool, extra: CGFloat)
    func showButton(show: Bool)
    func showWhere(show: Bool)
    
}

protocol MainPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, model: MainModeleProtocol, view: MainViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func keyboardWillShow(_ notification: Notification)
    func hideKeyboard()
    func settMapKit()
    func moveMyLocation()
    func pressMyLocation()
    func didUpdateLocations()
    func regionDidChangeAnimated()
    func textDidChange()
    func selectAddress()
    func openNewOrder()
    
}

protocol MainModeleProtocol: class {
    
    var fromAddress: Address? { get set }
    var whereAddress: Address? { get set }
    var dateStart: Int? { get set }
    
}

class MainModel: MainModeleProtocol {
    
    var fromAddress: Address?
    var whereAddress: Address?
    var dateStart: Int?
    
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: GeneralRouterProtocol?
    var model: MainModeleProtocol?
    var bottomView: MainBottomViewProtocol!
    var bottomSheet: BottomSheetView!
    var location: LocationHandeler!
    var mapDelegate: MKMapDelegate!
    var notificationCenter: NotificationCenter!
    var textFieldDelegate: TextFieldDelegate!
    var tableViewDelegate: TableViewDelegate!
    var collectionDelegate: CollectionDelegate!
    
    var fromDone: Bool = false
    var whereDone: Bool = false
    
    var keyboardHide: Bool = true
    
    required init(router: GeneralRouterProtocol, model: MainModeleProtocol, view: MainViewProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func viewDidLoad() {
        
        settMapKit()
        setNotificationCenter()
        
        location = LocationHandeler()
        textFieldDelegate = TextFieldDelegate()
        tableViewDelegate = TableViewDelegate()
        collectionDelegate = CollectionDelegate()
        
    }
    
    func viewWillAppear() {
        
        view?.enableHero()
        
        bottomView = MainBottomSheet()
        bottomSheet = BottomSheetView(contentView: bottomView, contentHeights: bottomView.contetntHeight)
        
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            DispatchQueue.main.async { [self] in bottomSheet.present(in: (view?.view)!, targetIndex: 0)}
        }
        
        bottomView.fromField.delegate = textFieldDelegate
        bottomView.whereField.delegate = textFieldDelegate
        
        bottomView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        bottomView.tableView.dataSource = tableViewDelegate
        bottomView.tableView.delegate = tableViewDelegate
        
        bottomView.showTable(show: false, extra: 0)
        bottomView.showButton(show: true)
        
    }
    
    func viewWillDisappear() {
        
        view?.disableHero()
        
    }
    
    func setNotificationCenter() {
        
        notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UITextField.keyboardWillShowNotification,
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(didUpdateLocations),
            name: NSNotification.Name(rawValue: "didUpdateLocations"),
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(regionDidChangeAnimated),
            name: NSNotification.Name(rawValue: "regionDidChangeAnimated"),
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(pressMyLocation),
            name: NSNotification.Name(rawValue: "pressMyLocation"),
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(textDidChange),
            name: NSNotification.Name(rawValue: "textDidChange"),
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(selectAddress),
            name: NSNotification.Name(rawValue: "pressNewAddtress"),
            object: nil)
        
//        notificationCenter.addObserver(
//            self,
//            selector: #selector(didRouteLaid),
//            name: NSNotification.Name(rawValue: "didRouteLaid"),
//            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector: #selector(openNewOrder),
            name: NSNotification.Name(rawValue: "pressPrice"),
            object: nil)
        
    }
    
    func settMapKit() {
        
        mapDelegate = MKMapDelegate()
        view?.mapView.delegate = mapDelegate
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            bottomView.keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        if keyboardHide {
            
            bottomView.showButton(show: false)
            bottomSheet.transition(to: 1)
            
            if textFieldDelegate.identifier == "from" {
                
                bottomView.showWhere(show: false)
                bottomView.showTable(show: true, extra: 60)
                
                if fromDone {
                    
                    let alert = UIAlertController(
                        title: "Хотите изменить маршрут доставки?",
                        message:  "",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(
                        title: "Нет",
                        style: .default,
                        handler: {(alert) in
                            
                            self.hideKeyboard()
                            self.view?.dismiss(animated: true, completion: nil)
                            
                        }))
                    
                    alert.addAction(UIAlertAction(
                        title: "Да",
                        style: .destructive,
                        handler: {(alert) in
                            
                            self.removeFrom()
                            self.view?.dismiss(animated: true, completion: nil)
                            
                        }))
                    
                    view?.present(alert, animated: true, completion: nil)
                    
                }
                
            } else if textFieldDelegate.identifier == "where" {
                
                bottomView.showWhere(show: true)
                bottomView.showTable(show: true, extra: 120)
                
                if whereDone {
                    
                    let alert = UIAlertController(
                        title: "Хотите изменить маршрут доставки?",
                        message:  "",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(
                        title: "Нет",
                        style: .default,
                        handler: {(alert) in
                            
                            self.hideKeyboard()
                            self.view?.dismiss(animated: true, completion: nil)
                            
                        }))
                    
                    alert.addAction(UIAlertAction(
                        title: "Да",
                        style: .destructive,
                        handler: {(alert) in
                            
                            self.removeWhere()
                            self.view?.dismiss(animated: true, completion: nil)
                            
                        }))
                    
                    view?.present(alert, animated: true, completion: nil)
                    
                }

            }
            
            
        }
        
        keyboardHide = false
        
    }
    
    func hideKeyboard() {
        
        if !keyboardHide {
            
            bottomView.endEditing(true)
            bottomSheet.transition(to: 0)
            
            bottomView.showTable(show: false, extra: 0)
            bottomView.showWhere(show: true)
            bottomView.showButton(show: true)
            
            keyboardHide = true
            
        }
        
    }
    
    func moveMyLocation() {
        
        if let coordinate = location.locations?[0].coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            view!.mapView.setRegion(region, animated: true)
        }
        
    }
    
    @objc func didUpdateLocations() {
        
        moveMyLocation()
        notificationCenter.removeObserver(self, name: NSNotification.Name(rawValue: "didUpdateLocations"), object: nil)
        
    }
    
    @objc func regionDidChangeAnimated() {
        
        let coordinate = mapDelegate.location
        
        if fromDone {
            
            let alert = UIAlertController(
                title: "Хотите изменить маршрут доставки?",
                message:  "",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(
                title: "Нет",
                style: .default,
                handler: {(alert) in
                    
                    self.mapDelegate.setMapRect()
                    self.view?.dismiss(animated: true, completion: nil)
                    
                }))
            
            alert.addAction(UIAlertAction(
                title: "Да",
                style: .destructive,
                handler: {(alert) in
                    
                    self.removeFrom()
                    self.view?.dismiss(animated: true, completion: nil)
                    
                }))
            
            view?.present(alert, animated: true, completion: nil)
            
        } else {
            
            MyGeocoder.getAddress(coordinate: coordinate!) { address in
                Network.getAddress(address: address) { addresses in
                    self.model!.fromAddress = addresses[0]
                    self.bottomView.fromField.text = addresses[0].Name
                    self.tableViewDelegate.addresses = addresses
                    self.bottomView.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    func removeFrom() {
        
        view?.mapView.removeOverlays((view?.mapView.overlays)!)
        view?.mapView.removeAnnotations((view?.mapView.annotations)!)
        
        fromDone = false
        view?.pinImage.isHidden = false
        
    }
    
    func removeWhere() {
        
        view?.mapView.removeOverlays((view?.mapView.overlays)!)
        view?.mapView.removeAnnotations((view?.mapView.annotations)!)
        
        whereDone = false
        
    }
    
    @objc func pressMyLocation() {
        
        if let coordinate = location.locations?[0].coordinate {
            MyGeocoder.getAddress(coordinate: coordinate) { address in
                Network.getAddress(address: address) { addresses in
                    self.model!.fromAddress = addresses[0]
                    self.bottomView.fromField.text = addresses[0].Name
                }
            }
        }
        
        hideKeyboard()
        moveMyLocation()
        
        self.tableViewDelegate.addresses = [Address]()
        self.bottomView.tableView.reloadData()
        
    }
    
    @objc func textDidChange() {
        
        if textFieldDelegate.text == "" {
            self.tableViewDelegate.addresses = [Address]()
            self.bottomView.tableView.reloadData()
        }
        
        Network.getAddress(address: textFieldDelegate.text) { addresses in
            self.tableViewDelegate.addresses = addresses
            self.bottomView.tableView.reloadData()
        }
        
    }
    
    @objc func selectAddress() {
        
        let address = tableViewDelegate.address!
        
        if textFieldDelegate.identifier == "from" {
            
            bottomView.fromField.text = address.Name
            
            if address.ID != nil {
                
                model!.fromAddress = address
                bottomView.whereField.becomeFirstResponder()
                bottomView.showWhere(show: true)
                bottomView.showTable(show: true, extra: 120)
                
                if let point = address.Point {
                    
                    let coordinate = CLLocationCoordinate2D(latitude: point.Latitude!, longitude: point.Longitude!)
                    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                    view!.mapView.setRegion(region, animated: true)
                    
                }
                
            }
            
        } else if textFieldDelegate.identifier == "where" {
            
            bottomView.whereField.text = address.Name
            
            if address.ID != nil {
                
                if model!.fromAddress!.ID != address.ID {
                    model!.whereAddress = address
                    hideKeyboard()
                    setRoute()
                }
                
            }
            
        }
        
        Network.getAddress(address: tableViewDelegate.address!.Name!) { addresses in
            self.tableViewDelegate.addresses = addresses
            self.bottomView.tableView.reloadData()
        }
        
    }
    
    func setRoute() {
        
        if model!.fromAddress?.Point != nil && model!.whereAddress?.Point != nil {
            
            fromDone = true
            whereDone = true
            
            view?.pinImage.isHidden = true
            mapDelegate.getRoute(from: model!.fromAddress!, where: model!.whereAddress!)
            
        }
        
    }
    
    @objc func openNewOrder() {
        router?.openNewOrder(model: model!)
    }
    
}
