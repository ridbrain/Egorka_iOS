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
    var collectionView: UICollectionView! { get set }
    
    func showCollection(show: Bool)
    func showTable(show: Bool, extra: CGFloat)
    func showButton(show: Bool)
    func showWhere(show: Bool)
    
}

protocol MainPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, view: MainViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func keyboardWillShow(_ notification: Notification)
    func hideKeyboard()
    func settMapKit()
    func moveMyLocation()
    func pressMyLocation()
    func didUpdateLocations()
    func regionDidChangeAnimated()
    func textDidChange()
    func selectAddress()
    
}

class MainPresenter: MainPresenterProtocol {

    weak var view: MainViewProtocol?
    var router: GeneralRouterProtocol?
    var bottomView: MainBottomViewProtocol!
    var bottomSheet: BottomSheetView!
    var location: LocationHandeler!
    var mapDelegate: MKMapDelegate!
    var notificationCenter: NotificationCenter!
    var textFieldDelegate: TextFieldDelegate!
    var tableViewDelegate: TableViewDelegate!
    var collectionDelegate: CollectionDelegate!
    
    var fromAddress: Address?
    var whereAddress: Address?
    var keyboardHide: Bool = true
    
    required init(router: GeneralRouterProtocol, view: MainViewProtocol) {
        self.view = view
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
        
        bottomView = MainBottomSheet()
        bottomSheet = BottomSheetView(contentView: bottomView, contentHeights: bottomView.contetntHeight)
        
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            DispatchQueue.main.async { [self] in
                bottomSheet.present(in: (view?.view)!, targetIndex: 0)
            }
        }
        
        bottomView.fromField.delegate = textFieldDelegate
        bottomView.whereField.delegate = textFieldDelegate
        
        bottomView.collectionView.register(TypeCollectionViewCell.nib, forCellWithReuseIdentifier: TypeCollectionViewCell.reuseID)
        bottomView.collectionView.dataSource = collectionDelegate
        bottomView.collectionView.delegate = collectionDelegate
        
        bottomView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        bottomView.tableView.dataSource = tableViewDelegate
        bottomView.tableView.delegate = tableViewDelegate
        
        bottomView.showCollection(show: true)
        bottomView.showTable(show: false, extra: 0)
        bottomView.showButton(show: false)
        
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
            
            bottomView.showCollection(show: false)
            bottomView.showButton(show: false)
            
            bottomSheet.transition(to: 1)
            
            if textFieldDelegate.identifier == "from" {
                
                bottomView.showWhere(show: false)
                bottomView.showTable(show: true, extra: 60)
                
            } else if textFieldDelegate.identifier == "where" {
                
                bottomView.showWhere(show: true)
                bottomView.showTable(show: true, extra: 120)

            }
            
        }
        
        keyboardHide = false
        
    }
    
    func hideKeyboard() {
        
        if !keyboardHide {
            
            bottomView.endEditing(true)
            bottomSheet.transition(to: 0)
            
            bottomView.showCollection(show: true)
            bottomView.showTable(show: false, extra: 0)
            bottomView.showWhere(show: true)
            bottomView.showButton(show: false)
            
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
        
        MyGeocoder.getAddress(coordinate: coordinate!) { address in
            Network.getAddress(address: address) { addresses in
                self.fromAddress = addresses[0]
                self.bottomView.fromField.text = addresses[0].Name
                self.tableViewDelegate.addresses = addresses
                self.bottomView.tableView.reloadData()
            }
        }
        
    }
    
    @objc func pressMyLocation() {
        
        if let coordinate = location.locations?[0].coordinate {
            MyGeocoder.getAddress(coordinate: coordinate) { address in
                Network.getAddress(address: address) { addresses in
                    self.fromAddress = addresses[0]
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
                
                fromAddress = address
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
                
                if fromAddress!.ID != address.ID {
                    whereAddress = address
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
        
        if fromAddress?.Point != nil && whereAddress?.Point != nil {
            
            let first = CLLocationCoordinate2D(latitude: fromAddress!.Point!.Latitude!, longitude: fromAddress!.Point!.Longitude!)
            let second = CLLocationCoordinate2D(latitude: whereAddress!.Point!.Latitude!, longitude: whereAddress!.Point!.Longitude!)
            
            view?.pinImage.isHidden = true
            mapDelegate.getRoute(from: first, where: second)
            
        }
        
    }
    
}
