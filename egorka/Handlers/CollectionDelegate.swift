//
//  CollectionDelegate.swift
//  egorka
//
//  Created by Виталий Яковлев on 15.12.2020.
//

import UIKit

struct TypeDelivery {
    var type: Int!
    var descr: String!
    var price: Float!
    var image: UIImage!
}

class CollectionDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var types = [
        TypeDelivery(type: 1, descr: "Пеший", price: 112.1, image: UIImage(named: "leg")),
        TypeDelivery(type: 2, descr: "Легковой", price: 212.1, image: UIImage(named: "car")),
        TypeDelivery(type: 3, descr: "Грузовой", price: 318.0, image: UIImage(named: "track"))]
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.reuseID, for: indexPath) as! TypeCollectionViewCell
        let type = types[indexPath.row]
        
        cell.label.text = type.descr
        cell.icon.image = type.image
        cell.price.text = "\(String(type.price)) ₽"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(100), height: CGFloat(85))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell: TypeCollectionViewCell = collectionView.cellForItem(at: indexPath) as? TypeCollectionViewCell {
            cell.layer.backgroundColor = UIColor.colorBackground.cgColor
            cell.label.textColor = UIColor.colorAccent
            cell.icon.tintColor = UIColor.colorAccent
            cell.price.textColor = UIColor.black
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell: TypeCollectionViewCell = collectionView.cellForItem(at: indexPath) as? TypeCollectionViewCell {
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.label.textColor = UIColor.black
            cell.icon.tintColor = UIColor.black
        }
    }
    
}
