//
//  TableViewCell.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 15.03.2021.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    static let reuseID = String(describing: LocationTableViewCell.self)
    static let nib = UINib(nibName: String(describing: LocationTableViewCell.self), bundle: nil)

    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numView: UIView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numImg: UIImageView!
    
    @IBOutlet weak var numHeigh: NSLayoutConstraint!
    @IBOutlet weak var numWidth: NSLayoutConstraint!

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        if highlighted {
            rootView.backgroundColor = UIColor.colorGray
        } else {
            rootView.backgroundColor = UIColor.white
        }
        
    }
    
    func setSize(size: NumState, text: String) {
        
        switch size {
        case .lite:
            numLabel.text = ""
            numHeigh.constant = 15
            numWidth.constant = 15
            numView.layer.cornerRadius = 7.5
        case .full:
            numLabel.text = text
            numHeigh.constant = 25
            numWidth.constant = 25
            numView.layer.cornerRadius = 12.5
        }
        
    }
    
}
