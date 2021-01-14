//
//  NewOrderPresenter.swift
//  egorka
//
//  Created by Виталий Яковлев on 24.12.2020.
//

import UIKit

protocol NewOrderViewProtocol: UIViewController {
    
    var presenter: NewOrderPresenterProtocol? { get set }
    
    var fromLabel: UILabel! { get set }
    var whereLabel: UILabel! { get set }
    var dateLabel: UILabel! { get set }
    
}

protocol NewOrderPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, model: MainModeleProtocol, view: NewOrderViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    
}

class NewOrderPresenter: NewOrderPresenterProtocol {
    
    weak var view: NewOrderViewProtocol?
    var router: GeneralRouterProtocol?
    var model: MainModeleProtocol!
    
    required init(router: GeneralRouterProtocol, model: MainModeleProtocol, view: NewOrderViewProtocol) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func viewDidLoad() {
        
        view?.fromLabel.text = model.fromAddress?.Name
        view?.whereLabel.text = model.whereAddress?.Name
        view?.dateLabel.text = "30.12 в 02:00" 
        
    }
    
    func viewWillAppear() {
        
        view?.enableHero()
        
    }
    
    func viewWillDisappear() {
        
        view?.disableHero()
        
    }
    
}
