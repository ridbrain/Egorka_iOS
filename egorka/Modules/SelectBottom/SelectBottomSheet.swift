//
//  SelectBottomSheet.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 11.05.2021.
//

import UIKit
import FINNBottomSheet

class SelectBottomSheet: UIView, SelectBottomViewProtocol {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var selectButton: RoundedButton!
    
    private var bottomSheet: BottomSheetView!
    private var contetntHeight: [[CGFloat]] = [[70], [150]]
    private var select: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xib = Bundle.main.loadNibNamed("SelectBottomSheet", owner: self, options: nil)![0] as! UIView
        xib.frame = self.bounds
        addSubview(xib)
        
        bottomSheet = BottomSheetView(contentView: self, contentHeights: contetntHeight[0])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentBottomView(view: UIView, label: String, select: @escaping () -> Void) {
        self.select = select
        addressLabel.text = label
        bottomSheet.present(in: view)
    }
    
    func updateAddress(address: String) {
        addressLabel.text = address
        selectButton.isHidden = false
        bottomSheet.reload(with: contetntHeight[1])
    }
    
    func hideSelectButton() {
        addressLabel.text = "Укажите адрес"
        selectButton.isHidden = true
        bottomSheet.reload(with: contetntHeight[0])
    }
    
    @IBAction func selectAddress(_ sender: Any) {
        if let select = select { select() }
    }
    
}
