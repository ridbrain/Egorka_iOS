//
//  TypeCollectionViewCell.swift
//  egorka
//
//  Created by Виталий Яковлев on 15.12.2020.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: TypeCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: TypeCollectionViewCell.self), bundle: nil)

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.contentView.layer.cornerRadius = 10
//        self.contentView.layer.borderWidth = 0
//        self.contentView.layer.masksToBounds = true

        self.layer.cornerRadius = 10
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
//        self.layer.shadowRadius = 4
//        self.layer.shadowOpacity = 0.1
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
    }

}
