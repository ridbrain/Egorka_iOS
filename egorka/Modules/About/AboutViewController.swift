//
//  AboutViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 30.03.2021.
//

import UIKit

class AboutViewController: UIViewController, AboutViewProtocol {
    
    var presenter: AboutPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "О приложении"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    @IBAction func pressVersion(_ sender: Any) {
        presenter?.pressVersion()
    }
    
}
