//
//  MarketplacePicker.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 04.05.2021.
//

import UIKit

class MarketplacePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var locations: [Marketplaces.Point]?
    var didSelectRow: ((Marketplaces.Point) -> Void)?
    
    required init(didSelectRow: ((Marketplaces.Point) -> Void)? = nil) {
        self.didSelectRow = didSelectRow
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations?[row].Name?[0].Name ?? "Ошибка"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let location = locations?[row] { didSelectRow?(location) }
    }
    
}
