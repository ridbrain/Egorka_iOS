//
//  NewOrderViewController.swift
//  egorka
//
//  Created by Виталий Яковлев on 26.12.2020.
//

import UIKit

class NewOrderViewController: UIViewController, NewOrderViewProtocol {
    
    var presenter: NewOrderPresenterProtocol?
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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

}
