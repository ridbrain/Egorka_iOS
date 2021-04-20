//
//  NoNetworkViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 10.03.2021.
//

import UIKit

class NoNetworkViewController: UIViewController, NoNetworkViewProtocol {
    
    var presenter: NoNetworkPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        
    }
    
    @IBAction func pressUpdate(_ sender: UIButton) {
        
    }
    
}
