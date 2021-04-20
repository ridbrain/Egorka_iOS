//
//  TestViewController.swift
//  egorka
//
//  Created by Виталий Яковлев on 18.12.2020.
//

import UIKit
import Hero

class SplashViewController: UIViewController, SplashViewProtocol {
    
    var presenter: SplashPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
}
