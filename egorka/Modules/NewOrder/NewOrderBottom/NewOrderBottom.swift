//
//  NewOrderBottom.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 24.03.2021.
//

import UIKit
import FINNBottomSheet

class NewOrderBottom: UIView, NewOrderBottomProtocol {
    
    private var contetntHeight: [[CGFloat]]!
    private var bottomSheet: BottomSheetView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var ancillaryPriceLabel: UILabel!
    @IBOutlet weak var tipPriceLabel: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var orderButton: RoundedButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xib = Bundle.main.loadNibNamed("NewOrderBottom", owner: self, options: nil)![0] as! UIView
        var bottomSafeArea = CGFloat(0)

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomSafeArea = (window?.safeAreaInsets.bottom) ?? 0
        }

        contetntHeight = [[0], [140 + bottomSafeArea], [235 + bottomSafeArea]]
        
        xib.frame = self.bounds
        addSubview(xib)
        
        bottomSheet = BottomSheetView(contentView: self, contentHeights: contetntHeight[0])
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentBottomView(view: UIView) {
        bottomSheet.present(in: view)
    }
    
    func transitionBottomView(index: Int) {
        bottomSheet.reload(with: contetntHeight[index])
    }
    
    func setInfoFields(type: TypeData, price: PriceTable) {
        typeIcon.image = type.icon
        typeLabel.text = type.label
        totalPriceLabel.text = "\(price.total) ₽"
        deliveryPriceLabel.text = "\(price.delivery) ₽ доставка"
        ancillaryPriceLabel.text = "\(price.ancillaries) ₽ доп. услуги"
        tipPriceLabel.text = "\(price.tcstax) ₽ сбор плат. сист."
    }
    
    func activeOrderButton(active: Bool) {
        
        if active {
            
            UIView.animate(withDuration: 0.5) {
                self.orderButton.alpha = 1
                self.orderButton.setTitle("ОПЛАТИТЬ ЗАКАЗ", for: .normal)
            }
            
        } else {
            
            UIView.animate(withDuration: 0.5) {
                self.orderButton.alpha = 0.5
                self.orderButton.setTitle("УКАЖИТЕ ДЕТАЛИ", for: .normal)
            }
            
        }
        
    }

}
