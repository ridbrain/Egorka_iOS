//
//  SideMenuViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 27.03.2021.
//

import UIKit

class SideMenuViewController: UIViewController, SideMenuViewProtocol {
    
    var presenter: SideMenuPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    @IBAction func pressCurrentOrder(_ sender: Any) {
        presenter?.openCurrentOrder()
    }
    
    @IBAction func pressAbout(_ sender: Any) {
        presenter?.openAbout()
    }
    
}
