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
    @IBOutlet weak var pickupFieldButton: UIButton!
    @IBOutlet weak var dropFieldButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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

        contetntHeight = [[125 + bottomSafeArea], [210 + bottomSafeArea], [screenHeight - topSafeSrea - 90]]
        
        xib.frame = self.bounds
        addSubview(xib)
        
        fromIcon.layer.cornerRadius = fromIcon.frame.height / 2
        fromIcon.layer.borderWidth = 2
        fromIcon.layer.borderColor = UIColor.colorAccent.cgColor
        whereIcon.layer.cornerRadius = whereIcon.frame.height / 2
        whereIcon.layer.borderWidth = 2
        whereIcon.layer.borderColor = UIColor.colorBlue.cgColor
        
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
            self.presenter?.openNewOrder(order: delivery)
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
    
    func showTable(show: Bool, extra: CGFloat) {
        
        if show {
            tableView.isHidden = false
            tableHeight.constant = contetntHeight[2][0] - extra - keyboardHeight!
        } else {
            tableView.isHidden = true
            tableHeight.constant = 0
        }
        
    }
    
    func showButtons(show: Bool) {
        collectionView.isHidden = !show
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

                while h < height {

                    usleep(100)

                    DispatchQueue.main.async {
                        self.whereHeight.constant = CGFloat(h)
                    }

                    h = h + 1

                }

            }
            
            whereIcon.isHidden = false
            whereField.isHidden = false
            dropFieldButton.isHidden = false
            
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
            
            whereIcon.isHidden = true
            whereField.isHidden = true
            
        }
        
    }
    
    func getPickupText() -> String {
        return fromField.text ?? ""
    }
    
    func getDropText() -> String {
        return whereField.text ?? ""
    }
    
    func changeIconPickupField(edit: Bool) {
        
        if edit {
            if pickupFieldButton.image(for: .normal) != UIImage(named: "Remove")! {
                pickupFieldButton.changeIcon(image: UIImage(named: "Remove")!, color: .lightGray)
            }
        } else {
            if pickupFieldButton.image(for: .normal) != UIImage(named: "Crosshair")! {
                pickupFieldButton.changeIcon(image: UIImage(named: "Crosshair")!, color: .colorAccent)
            }
        }
        
    }
    
    func showIconDropField(show: Bool) {
        
//        if whereHeight.constant == 45 {
//            if show {
//                dropFieldButton.changeIcon(image: UIImage(named: "Remove")!, color: .lightGray)
//            } else {
//                dropFieldButton.hideIcon()
//            }
//        } else {
//            dropFieldButton.hideIcon()
//        }
        
        if whereHeight.constant == 45 {
            dropFieldButton.isHidden = !show
        } else {
            dropFieldButton.isHidden = true
        }
        
    }
    
    @IBAction func pressPickupFieldButton(_ sender: Any) {
        presenter?.pressPickupFieldButton()
    }
    
    @IBAction func pressDropFieldButton(_ sender: Any) {
        presenter?.pressDropFieldButton()
    }
    
}
