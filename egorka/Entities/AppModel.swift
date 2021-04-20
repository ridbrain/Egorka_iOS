//
//  AppModel.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 11.03.2021.
//

import Foundation

protocol MainModeleProtocol: class {
    
    var pickups: [NewOrderLocation]? { get set }
    var drops: [NewOrderLocation]? { get set }
    
}

class MainModel: MainModeleProtocol {
    
    var pickups: [NewOrderLocation]?
    var drops: [NewOrderLocation]?
    
}
