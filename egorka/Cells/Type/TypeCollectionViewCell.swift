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
        
        self.layer.cornerRadius = 10
//        self.layer.backgroundColor = UIColor.white.cgColor
        
    }

}
