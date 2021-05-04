//
//  AboutProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 21.04.2021.
//

import UIKit

protocol AboutViewProtocol: UIViewController {
    
    var presenter: AboutPresenterProtocol? { get set }
    
}

protocol AboutPresenterProtocol: AnyObject {
    
    init(router: GeneralRouterProtocol, view: AboutViewProtocol)
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func pressVersion()
    
}
