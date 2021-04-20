//
//  DetailsViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 16.03.2021.
//

import UIKit

class DetailsViewController: UIViewController, DetailsViewProtocol {
    
    var presenter: DetailsPresenterProtocol?
    
    @IBOutlet weak var addresLabel: UILabel!
    @IBOutlet weak var contactsLabel: UILabel!
    @IBOutlet weak var numView: UIView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var addressField: UILabel!
    @IBOutlet weak var entranceField: UITextField!
    @IBOutlet weak var floorField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet weak var messageField: UITextView!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var contactsMargin: NSLayoutConstraint!
    
    private var datePicker = UIDatePicker()
    private var timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Указать детали"
        numView.layer.cornerRadius = numView.frame.height / 2
        numView.layer.borderWidth = 2
        
        addressField.isUserInteractionEnabled = true
        addressField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressAddress)))
        
        presenter?.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    @IBAction func quicklySwitch(_ sender: UISwitch) {
        presenter?.setQuickly(quickly: sender.isOn)
    }
    
    func setDelete() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: #selector(deleteAddress))
    }
    
    @objc func deleteAddress() {
        presenter?.deleteAddress()
    }
    
    func setDateDelegate() {
        
        datePicker.datePickerMode = .date
        timePicker.datePickerMode = .time
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            timePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.timeZone = TimeZone(secondsFromGMT: 10800)
        timePicker.timeZone = TimeZone(secondsFromGMT: 10800)
        
        dateField.inputView = datePicker
        timeField.inputView = timePicker
        
        datePicker.addTarget(self, action: #selector(updateDateField), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(updateTimeField), for: .valueChanged)
        
    }
    
    @objc func updateDateField() {
        
        setDate(text: DateFormatter().gmt3().dayMonthYear(date: datePicker.date))
        timePicker.setDate(datePicker.date, animated: false)
        
    }
    
    @objc func updateTimeField() {
        
        setTime(text: DateFormatter().gmt3().hoursMins(date: timePicker.date))
        datePicker.setDate(timePicker.date, animated: false)
        
    }
    
    func setPickerDate(date: Date, time: Date) {
        
        datePicker.setDate(date, animated: false)
        timePicker.setDate(time, animated: false)
        
    }
    
    func getPickerDate() -> Date {
        return datePicker.date
    }
    
    func getPickerTime() -> Date {
        return timePicker.date
    }
    
    func setLabels(address: String, contacts: String) {
        addresLabel.text = address
        contactsLabel.text = contacts
    }
    
    func getLabel() -> String {
        return addresLabel.text ?? "Введите точный адрес"
    }
    
    func setNum(color: UIColor, label: String) {
        
        numView.layer.borderColor = color.cgColor
        numLabel.text = label
        
        numView.heroID = "numView\(label)"
        numLabel.heroID = "numLabel\(label)"
        
    }
    
    func setVisibleDateView(state: Int) {
        
        if state == 0 {
            dateView.isHidden = true
            contactsMargin.constant = 15
        } else if state == 1 {
            dateView.isHidden = false
            timeView.isHidden = true
            contactsMargin.constant = 103
            dateSwitch.isOn = true
        } else if state == 2 {
            dateView.isHidden = false
            timeView.isHidden = false
            contactsMargin.constant = 158
            dateSwitch.isOn = false
        }
        
    }
    
    @objc func pressAddress(_ sender: Any) {
        presenter?.pressAddress()
    }
    
    func setAddress(text: String) {
        addressField.text = text
    }
    
    func setEntrance(text: String) {
        entranceField.text = text
    }
    
    func setFloor(text: String) {
        floorField.text = text
    }
    
    func setRoom(text: String) {
        roomField.text = text
    }
    
    func setName(text: String) {
        nameField.text = text
    }
    
    func setPhone(text: String) {
        phoneField.text = text
    }
    
    func setMessage(text: String) {
        messageField.text = text
    }
    
    func setDate(text: String) {
        dateField.text = text
    }
    
    func setTime(text: String) {
        timeField.text = text
    }
    
    func getName() -> String? {
        return nameField.text
    }
    
    func getPhone() -> String? {
        return phoneField.text
    }
    
    func getEntrance() -> String? {
        return entranceField.text
    }
    
    func getFloor() -> String? {
        return floorField.text
    }
    
    func getRoom() -> String? {
        return roomField.text
    }
    
    func getMessage() -> String? {
        return messageField.text
    }
    
    func getSwitchState() -> Bool {
        return dateSwitch.isOn
    }
    
}
