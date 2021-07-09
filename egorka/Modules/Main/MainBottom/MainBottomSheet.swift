//
//  MainBottomSheet.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import FINNBottomSheet

class MainBottomSheet: UIView, MainBottomViewProtocol {
    
    var presenter: MainPresenterProtocol?
    
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var whereField: UITextField!
    @IBOutlet weak var whereIcon: UIView!
    @IBOutlet weak var fromIcon: UIView!
    @IBOutlet weak var mapPickup: UIButton!
    @IBOutlet weak var mapDrop: UIButton!
    @IBOutlet weak var clearPickup: UIButton!
    @IBOutlet weak var clearDrop: UIButton!
    @IBOutlet weak var clearPickupWidth: NSLayoutConstraint!
    @IBOutlet weak var clearDropWidth: NSLayoutConstraint!
    @IBOutlet weak var mapDropWidth: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderButton: RoundedButton!
    
    @IBOutlet weak var whereMargin: NSLayoutConstraint!
    @IBOutlet weak var whereHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    private var contetntHeight: [[CGFloat]]!
    private var keyboardHeight: CGFloat?
    private var bottomSheet: BottomSheetView!
    private var pickupFieldDelegate: TextFieldDelegate!
    private var dropFieldDelegate: TextFieldDelegate!
    private var tableViewDelegate: AddressTableView!
    private var collectionDelegate: CollectionDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xib = Bundle.main.loadNibNamed("MainBottomSheet", owner: self, options: nil)![0] as! UIView
        let screenHeight = UIScreen.main.bounds.size.height
        var topSafeSrea = CGFloat(0)
        var bottomSafeArea = CGFloat(0)

        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topSafeSrea = (window?.safeAreaInsets.top) ?? 0
            bottomSafeArea = (window?.safeAreaInsets.bottom) ?? 0
        }

        contetntHeight = [[120 + bottomSafeArea], [260 + bottomSafeArea], [screenHeight - topSafeSrea - 90]]
        
        xib.frame = self.bounds
        addSubview(xib)
        
        fromIcon.layer.cornerRadius = fromIcon.frame.height / 2
        fromIcon.layer.borderWidth = 2
        fromIcon.layer.borderColor = UIColor.colorAccent.cgColor
        whereIcon.layer.cornerRadius = whereIcon.frame.height / 2
        whereIcon.layer.borderWidth = 2
        whereIcon.layer.borderColor = UIColor.colorBlue.cgColor
        clearDropWidth.constant = 0
        mapDropWidth.constant = 0
        
        bottomSheet = BottomSheetView(contentView: self, contentHeights: contetntHeight[0], handleBackground: .color(.colorBackground))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setKeyboardHeight(height: CGFloat) {
        keyboardHeight = height
    }
    
    func initTextDelegate() {
        
        pickupFieldDelegate = TextFieldDelegate() { text in
            self.presenter?.textDidChange(text: text)
        }
        
        dropFieldDelegate = TextFieldDelegate() { text in
            self.presenter?.textDidChange(text: text)
        }
        
        fromField.delegate = pickupFieldDelegate
        whereField.delegate = dropFieldDelegate
        
    }
    
    func getFocuseField() -> FocusField? {
        
        if fromField.isEditing {
            return .pickup
        } else if whereField.isEditing {
            return .drop
        }
        
        return nil
        
    }
    
    func setFieldEdit(field: FocusField) {
        
        switch field {
        case .pickup:
            fromField.becomeFirstResponder()
        case .drop:
            whereField.becomeFirstResponder()
        }
        
    }
    
    func setTextField(field: FocusField, text: String) {
        
        switch field {
        case .pickup:
            fromField.text = text
        case .drop:
            whereField.text = text
        }
        
    }
    
    func setSuggestions(suggestions: [Dictionary.Suggestion]) {
        tableViewDelegate.suggestions = suggestions
        tableView.reloadData()
    }
    
    func initTableView() {
        
        tableViewDelegate = AddressTableView() { suggestion in
            self.presenter?.selectAddress(address: suggestion)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = tableViewDelegate
        tableView.delegate = tableViewDelegate
        
    }
    
    func initCollectionView() {
        
        collectionDelegate = CollectionDelegate() { delivery in
            self.presenter?.selectDelivery(delivery: delivery)
        }
        
        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDelegate
        collectionView.register(TypeCollectionViewCell.nib, forCellWithReuseIdentifier: TypeCollectionViewCell.reuseID)
        
    }
    
    func reloadCollection(types: [Delivery]) {
        collectionDelegate.types = types
        collectionView.reloadData()
    }
    
    func presentBottomView(view: UIView) {
        bottomSheet.present(in: view)
    }
    
    func transitionBottomView(state: BottomState) {
        
        switch state {
        case .small:
            bottomSheet.reload(with: contetntHeight[0])
        case .medium:
            bottomSheet.reload(with: contetntHeight[1])
        case .big:
            bottomSheet.reload(with: contetntHeight[2])
        }
        
    }
    
    func showTable(show: Bool) {
        
        if show {
            tableView.isHidden = false
            tableHeight.constant = contetntHeight[2][0] - 115 - keyboardHeight!
        } else {
            tableView.isHidden = true
            tableHeight.constant = 0
        }
        
    }
    
    func showButtons(show: Bool) {
        collectionView.isHidden = !show
    }
    
    func getPickupText() -> String {
        return fromField.text ?? ""
    }
    
    func getDropText() -> String {
        return whereField.text ?? ""
    }
    
    @IBAction func pressClearPickup(_ sender: Any) {
        presenter?.pressClearPickupField()
    }
    
    @IBAction func pressMapPickup(_ sender: Any) {
        presenter?.pressMyLocation()
    }
    
    @IBAction func pressClearDrop(_ sender: Any) {
        presenter?.pressClearDropField()
    }
    
    @IBAction func pressMapDrop(_ sender: Any) {
        presenter?.pressMapDropField()
    }
    
    func showClearDrop(show: Bool) {
        
        clearDropWidth.constant = 35
        mapDropWidth.constant = 35
        
        if show && mapDrop.imageView?.image != .icMap {
            mapDrop.changeIcon(image: .icMap)
            clearDrop.changeIcon(image: .icRemove) { _ in
                if self.clearDropWidth.constant != 35 { self.clearDropWidth.constant = 35 }
            }
        } else if !show {
            clearDrop.hideIcon() { _ in self.clearDropWidth.constant = 0 }
            mapDrop.hideIcon() { _ in self.clearDropWidth.constant = 0 }
        }
        
    }
    
    func showClearPickup(show: Bool) {
        
        clearPickupWidth.constant = 35
        
        if show && clearPickup.imageView?.image != .icRemove {
            clearPickup.changeIcon(image: .icRemove) { _ in
                if self.clearPickupWidth.constant != 35 { self.clearPickupWidth.constant = 35 }
            }
        } else if !show {
            clearPickup.hideIcon() { _ in self.clearPickupWidth.constant = 0 }
        }
        
    }

    func activeOrderButton(active: Bool) {
        
        if active {
            
            UIView.animate(withDuration: 0.5) {
                self.orderButton.alpha = 1
                self.orderButton.setTitle("ОФОРМИТЬ ЗАКАЗ", for: .normal)
            }
            
        } else {
            
            UIView.animate(withDuration: 0.5) {
                self.orderButton.alpha = 0.5
                self.orderButton.setTitle("ВЫБИРИТЕ СПОСОБ ДОСТАВКИ", for: .normal)
            }
            
        }
        
    }
    
    @IBAction func pressNewOrder(_ sender: Any) {
        presenter?.openNewOrder()
    }
    
}
