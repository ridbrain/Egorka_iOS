//
//  SplashProtocols.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 07.04.2021.
//

import UIKit

protocol SplashViewProtocol: UIViewController {
    
    var presenter: SplashPresenterProtocol? { get set }
    
}

protocol SplashPresenterProtocol: class {
    
    init(router: GeneralRouterProtocol, view: SplashViewProtocol)
    
    func viewWillAppear()
    func viewWillDisappear()
    
}
