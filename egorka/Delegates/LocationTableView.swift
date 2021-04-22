//
//  LocationTableView.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 16.03.2021.
//

import UIKit

enum NumState {
    case full
    case lite
}

class LocationTableView: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var numState: NumState!
    var locations: [Location]?
    var didSelectRow: ((Location, Int) -> Void)?
    var deleteRow: ((LocationType, Int) -> Void)?
    
    required init(didSelectRow: ((Location, Int) -> Void)? = nil, deleteRow: ((LocationType, Int) -> Void)? = nil) {
        self.numState = .lite
        self.didSelectRow = didSelectRow
        self.deleteRow = deleteRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(85)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseID, for: indexPath) as! LocationTableViewCell
        let location = locations![indexPath.row]
        
        switch location.Type {
        case .Pickup:
            cell.numView.layer.borderWidth = 2
            cell.numView.layer.borderColor = UIColor.colorAccent.cgColor
            cell.setSize(size: numState, text: "A\(indexPath.row + 1)")
        case .Drop:
            cell.numView.layer.borderWidth = 2
            cell.numView.layer.borderColor = UIColor.colorBlue.cgColor
            cell.setSize(size: numState, text: "B\(indexPath.row + 1)")
        case .none:
            cell.numView.backgroundColor = .white
            cell.numLabel.text = ""
        }
        
        cell.addressLabel.text = location.Point?.Address
        
        if let descr = location.Contact {
            cell.descriptionLabel.text = "\(descr.Name ?? ""), \(descr.PhoneMobile ?? "")"
            cell.descriptionLabel.textColor = .darkGray
        } else {
            cell.descriptionLabel.text = "Указать детали"
            cell.descriptionLabel.textColor = .colorAccentLight
        }
        
        if location.Type == LocationType.Drop && locations?.last?.Point?.Code == location.Point?.Code {
            cell.numImg.image = .icFlag
        } else {
            cell.numImg.image = .icDown
        }
        
        cell.numView.heroID = "numView\(cell.numLabel.text!)"
        cell.numLabel.heroID = "numLabel\(cell.numLabel.text!)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.row > 0 {
            
            let delete = UITableViewRowAction(style: .destructive, title: "Удалить") { (action, indexPath) in
                
                self.deleteRow?(self.locations![indexPath.row].Type!, indexPath.row)

            }
            
            return [delete]
            
        } else {
            
            return nil
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelectRow?(locations![indexPath.row], indexPath.row)
        
    }
    
}
