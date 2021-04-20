//
//  NewOrderBottom.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 24.03.2021.
//

import UIKit
import FINNBottomSheet

class NewOrderBottom: UIView, NewOrderBottomProtocol {
    
    var presenter: NewOrderPresenter?
    
    private var contetntHeight: [[CGFloat]]!
    private var bottomSheet: BottomSheetView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xib = Bundle.main.loadNibNamed("NewOrderBottom", owner: self, options: nil)![0] as! UIView
        var bottomSafeArea = CGFloat(0)

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomSafeArea = (window?.safeAreaInsets.bottom) ?? 0
        }

        contetntHeight = [[140 + bottomSafeArea], [235 + bottomSafeArea]]
        
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

}
