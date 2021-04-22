//
//  AppModel.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 11.03.2021.
//

import Foundation

protocol MainModeleProtocol: class {
    
    var pickups: [Location]? { get set }
    var drops: [Location]? { get set }
    
}

class MainModel: MainModeleProtocol {
    
    var pickups: [Location]?
    var drops: [Location]?
    
}
