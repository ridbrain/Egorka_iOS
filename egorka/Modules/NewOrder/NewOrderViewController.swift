//
//  NewOrderViewController.swift
//  egorka
//
//  Created by Виталий Яковлев on 26.12.2020.
//

import UIKit

class NewOrderViewController: UIViewController, NewOrderViewProtocol {
    
    var presenter: NewOrderPresenterProtocol?
    
    @IBOutlet weak var pickupTableView: UITableView!
    @IBOutlet weak var dropTableView: UITableView!
    @IBOutlet weak var pickupsHeight: NSLayoutConstraint!
    @IBOutlet weak var dropsHeight: NSLayoutConstraint!
    
    private var pickupTableDelegate: LocationTableView!
    private var dropTableDelegate: LocationTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancel))
        
        presenter?.viewDidLoad()
        
    }
    
    @objc func cancel() {
        presenter?.cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    func setTitle(title: String) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = title
    }
    
    func setTableViews() {
        
        pickupTableDelegate = LocationTableView(didSelectRow: { loacation, index in
            self.presenter?.openDetails(location: loacation, index: index)
        }, deleteRow: { indexPath, routeOrder in
            self.pickupTableView.deleteRows(at: [indexPath], with: .fade)
            self.presenter?.deleteLocation(routeOrder: routeOrder)
        })
        
        dropTableDelegate = LocationTableView(didSelectRow: { loacation, index in
            self.presenter?.openDetails(location: loacation, index: index)
        }, deleteRow: { indexPath, routeOrder in
            self.dropTableView.deleteRows(at: [indexPath], with: .fade)
            self.presenter?.deleteLocation(routeOrder: routeOrder)
        })
        
        pickupTableView.setCorner()
        pickupTableView.delegate = pickupTableDelegate
        pickupTableView.dataSource = pickupTableDelegate
        pickupTableView.register(LocationTableViewCell.nib, forCellReuseIdentifier: LocationTableViewCell.reuseID)
        
        dropTableView.setCorner()
        dropTableView.delegate = dropTableDelegate
        dropTableView.dataSource = dropTableDelegate
        dropTableView.register(LocationTableViewCell.nib, forCellReuseIdentifier: LocationTableViewCell.reuseID)
        
    }
    
    func updateTables(pickups: [Location], drops: [Location], numState: NumState) {
        
        pickupTableDelegate.numState = numState
        dropTableDelegate.numState = numState
        
        pickupTableDelegate.locations = pickups
        dropTableDelegate.locations = drops
        
        pickupsHeight.constant = CGFloat(85 * pickups.count)
        dropsHeight.constant = CGFloat(85 * drops.count)
        
        pickupTableView.reloadData()
        dropTableView.reloadData()
        
    }
    
    func showWarning() {
        
        let alert = UIAlertController(
            title: "Внимание",
            message:  "Маршрут будет удалён. Отменить оформление заказа?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Да",
            style: .destructive,
            handler: { alert in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
        
        alert.addAction(UIAlertAction(
            title: "Нет",
            style: .default,
            handler: { alert  in
                self.dismiss(animated: true, completion: nil)
            }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func pressAddPickup(_ sender: Any) {
        presenter?.newPickup()
    }
    
    @IBAction func pressAddDrop(_ sender: Any) {
        presenter?.newDrop()
    }
    
}
