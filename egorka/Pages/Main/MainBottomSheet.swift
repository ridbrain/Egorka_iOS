//
//  MainBottomSheet.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import DCKit

class MainBottomSheet: UIView, MainBottomViewProtocol {
    
    var contetntHeight: [CGFloat]!
    var keyboardHeight: CGFloat?
    
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var whereField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceButton: DCBorderedButton!
    
    @IBOutlet weak var whereMargin: NSLayoutConstraint!
    @IBOutlet weak var whereHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        
        let xib = Bundle.main.loadNibNamed("MainBottomSheet", owner: self, options: nil)![0] as! UIView
        let screenHeight = UIScreen.main.bounds.size.height
        var topSafeSrea = CGFloat(0)
        var bottomSafeArea = CGFloat(0)

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topSafeSrea = (window?.safeAreaInsets.top) ?? 0
            bottomSafeArea = (window?.safeAreaInsets.bottom) ?? 0
        }

        contetntHeight = [225 + bottomSafeArea, screenHeight - topSafeSrea - 90]
        
        xib.frame = self.bounds
        addSubview(xib)
        
    }
    
    func showCollection(show: Bool) {
        
        if show {
            collectionView.isHidden = false
            collectionHeight.constant = 110
        } else {
            collectionView.isHidden = true
            collectionHeight.constant = 0
        }
        
    }
    
    func showTable(show: Bool, extra: CGFloat) {
        
        if show {
            tableView.isHidden = false
            tableHeight.constant = contetntHeight[1] - extra - keyboardHeight!
        } else {
            tableView.isHidden = true
            tableHeight.constant = 0
        }
        
    }
    
    func showButton(show: Bool) {
        priceButton.isHidden = !show
    }
    
    func showWhere(show: Bool) {
        
        let height = 45
        let margin = 15
        
        if show && whereHeight.constant != CGFloat(height) {
            
            DispatchQueue.global(qos: .background).async {
                
                var m = 1

                while m <= margin {

                    usleep(100)

                    DispatchQueue.main.async {
                        self.whereMargin.constant = CGFloat(m)
                    }

                    m = m + 1

                }

                var h = 1

                while h <= height {

                    usleep(100)

                    DispatchQueue.main.async {
                        self.whereHeight.constant = CGFloat(h)
                    }

                    h = h + 1

                }

            }
            
        } else if !show && whereHeight.constant != CGFloat(0) {
            
            DispatchQueue.global(qos: .background).async {

                var h = height

                while h != 0 {

                    usleep(100)

                    DispatchQueue.main.async {
                        self.whereHeight.constant = CGFloat(h)
                    }

                    h = h - 1

                }
                
                var m = margin

                while m != 0 {

                    usleep(100)

                    DispatchQueue.main.async {
                        self.whereMargin.constant = CGFloat(m)
                    }

                    m = m - 1

                }

            }
            
        }
        
    }
    
    @IBAction func pressMyLocation(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pressMyLocation"), object: nil)
        
    }
    
}
