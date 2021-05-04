//
//  AddressBottomSheet.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 20.03.2021.
//

import UIKit
import DCKit
import FINNBottomSheet

class AddressBottomSheet: UIView, AddressBottomViewProtocol {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    private var contetntHeight: [CGFloat]!
    private var bottomSheet: BottomSheetView?
    private var addressFieldDelegate: TextFieldDelegate!
    private var tableViewDelegate: AddressTableView!
    private var sheetHiden = true
    
    var textDidChange: ((String?) -> Void)?
    var selectAddress: ((Dictionary.Suggestion) -> Void)?
    var sheetHide: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let xib = Bundle.main.loadNibNamed("AddressBottomSheet", owner: self, options: nil)![0] as! UIView
        let screenHeight = UIScreen.main.bounds.size.height
        var topSafeSrea = CGFloat(0)

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topSafeSrea = (window?.safeAreaInsets.top) ?? 0
        }

        contetntHeight = [screenHeight - topSafeSrea - 155]

        xib.frame = self.bounds
        addSubview(xib)
        
        addressFieldDelegate = TextFieldDelegate() { if let fun = self.textDidChange { fun($0) } }
        addressField.delegate = addressFieldDelegate
        
        tableViewDelegate = AddressTableView() { if let fun = self.selectAddress { fun($0) } }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = tableViewDelegate
        tableView.delegate = tableViewDelegate

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTableHeight(height: CGFloat) {
        tableHeight.constant = contetntHeight[0] - height - 88
    }
    
    func presentBottomView(view: UIView, text: String) {
        
        if sheetHiden {
            
            bottomSheet = BottomSheetView(contentView: self, contentHeights: contetntHeight, handleBackground: .color(.colorBackground))
            bottomSheet?.present(in: view)
            
            sheetHiden = false
            addressLabel.text = text
            addressField.becomeFirstResponder()
            
        }
        
    }
    
    func setAddressText(text: String) {
        addressField.text = text
        addressField.becomeFirstResponder()
        addressField.selectedTextRange = addressField.textRange(from: addressField.endOfDocument, to: addressField.endOfDocument)
    }
    
    func setSuggestions(suggestions: [Dictionary.Suggestion]) {
        tableViewDelegate.suggestions = suggestions
        tableView.reloadData()
    }
    
    func dismiss() {
        
        self.endEditing(true)
        
        bottomSheet?.dismiss() { bool in
            self.sheetHiden = bool
            if let fun = self.sheetHide { fun() }
        }
        
    }
    
    @IBAction func pressCancel(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func pressClearAddress(_ sender: Any) {
        setAddressText(text: "")
    }
    
}
