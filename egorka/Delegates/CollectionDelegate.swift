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
    
    var types = [Delivery]()
    var didDeselectItem: (Delivery) -> Void
    
    required init(didDeselectItem: @escaping (Delivery) -> Void) {
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
        let typeData = TypeData(type: type.Type!)
        
        cell.label.text = typeData.label
        cell.icon.image = typeData.icon
        cell.price.text = "\(String(type.Result!.TotalPrice!.Total! / 100)) ₽"
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
            
            cell.label.textColor = UIColor.black
            cell.icon.tintColor = UIColor.black
            
        }
        
    }
    
    func selectCell(collectionView: UICollectionView, indexPath: IndexPath) {
        
        if let cell: TypeCollectionViewCell = collectionView.cellForItem(at: indexPath) as? TypeCollectionViewCell {
            
            cell.label.textColor = UIColor.colorAccent
            cell.icon.tintColor = UIColor.colorAccent
            
        }
        
        didDeselectItem(types[indexPath.row])
        
    }
    
}
