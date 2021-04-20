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
    
    var didDeselectItem: (Int) -> Void
    var types = [
        TypeDelivery(type: 1, descr: "Пеший", price: 0, image: UIImage(named: "leg")),
        TypeDelivery(type: 3, descr: "Скутер", price: 0, image: UIImage(named: "bike")),
        TypeDelivery(type: 2, descr: "Легковой", price: 0, image: UIImage(named: "car")),
        TypeDelivery(type: 3, descr: "Грузовой", price: 0, image: UIImage(named: "track"))]
    
    required init(didDeselectItem: @escaping (Int) -> Void) {
        self.didDeselectItem = didDeselectItem
    }
    
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
        
        if type.price == 0 {
            cell.price.text = "--- ₽"
        } else {
            cell.price.text = "\(String(type.price)) ₽"
        }
        
//        cell.layer.backgroundColor = UIColor.colorGrayLight.cgColor
        cell.label.textColor = UIColor.black
        cell.icon.tintColor = UIColor.black
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(90), height: CGFloat(70))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectCell(collectionView: collectionView, indexPath: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        deselectCell(collectionView: collectionView, indexPath: indexPath)
        
    }
    
    func deselectCell(collectionView: UICollectionView, indexPath: IndexPath) {
        
        if let cell: TypeCollectionViewCell = collectionView.cellForItem(at: indexPath) as? TypeCollectionViewCell {
            
//            cell.layer.backgroundColor = UIColor.colorGrayLight.cgColor
            cell.label.textColor = UIColor.black
            cell.icon.tintColor = UIColor.black
            
        }
        
    }
    
    func selectCell(collectionView: UICollectionView, indexPath: IndexPath) {
        
        if let cell: TypeCollectionViewCell = collectionView.cellForItem(at: indexPath) as? TypeCollectionViewCell {
            
//            cell.layer.backgroundColor = UIColor.colorGray.cgColor
            cell.label.textColor = UIColor.colorAccent
            cell.icon.tintColor = UIColor.colorAccent
            
        }
        
        didDeselectItem(indexPath.row)
        
    }
    
}
