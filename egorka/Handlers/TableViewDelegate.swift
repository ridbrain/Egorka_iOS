//
//  TableViewDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 12.12.2020.
//

import UIKit

class TableViewDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var address: Address?
    var addresses: [Address]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let address = addresses![indexPath.row]
        
        cell.textLabel?.text = address.Name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        address = addresses![indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pressNewAddtress"), object: nil)
        
    }
    
}
