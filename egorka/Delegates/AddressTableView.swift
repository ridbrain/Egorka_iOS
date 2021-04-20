//
//  TableViewDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 12.12.2020.
//

import UIKit

class AddressTableView: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var suggestions: [Suggestion]?
    var didSelectRow: (Suggestion) -> Void
    
    required init(didSelectRow: @escaping (Suggestion) -> Void) {
        self.didSelectRow = didSelectRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let address = suggestions![indexPath.row]
        
        cell.textLabel?.text = address.Name
        cell.backgroundColor = .colorBackground
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(suggestions![indexPath.row])
    }
    
}
