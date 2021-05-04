//
//  MarketplaceViewController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 03.05.2021.
//

import UIKit
import JMMaskTextField_Swift

class MarketplaceViewController: UIViewController, MarketplaceViewProtocol {
    
    var presenter: MarketplacePresenterProtocol?
    
    @IBOutlet weak var pickupIcon: UIView!
    @IBOutlet weak var dropIcon: UIView!
    
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var dropField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: JMMaskTextField!
    @IBOutlet weak var boxCountLabel: UILabel!
    @IBOutlet weak var palletCountLabel: UILabel!
    @IBOutlet weak var messageField: UITextView!
    
    private var datePicker = UIDatePicker()
    private var placePicker = UIPickerView()
    private var placeDelegate: MarketplacePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickupIcon.layer.cornerRadius = pickupIcon.frame.height / 2
        pickupIcon.layer.borderWidth = 2
        pickupIcon.layer.borderColor = UIColor.colorAccent.cgColor
        dropIcon.layer.cornerRadius = dropIcon.frame.height / 2
        dropIcon.layer.borderWidth = 2
        dropIcon.layer.borderColor = UIColor.colorBlue.cgColor
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancel))
        
        pickupLabel.isUserInteractionEnabled = true
        pickupLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressAddress)))
        
        setDateDelegate()
        
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
    
    @objc func cancel() {

        let alert = UIAlertController(
            title: "Внимание",
            message:  "Маршрут будет удалён. Отменить оформление заказа?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Да",
            style: .destructive,
            handler: { alert in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }))
        
        alert.addAction(UIAlertAction(
            title: "Нет",
            style: .default,
            handler: { alert  in
                self.dismiss(animated: true, completion: nil)
            }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func pressHowWork(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message:  "Доставка до маркетплейсов стала простой и доступной.Больше не нужно звонить в рабочее время нашему менеджеру и оформлять заказ по телефону. Теперь заказ вы можете оформить самостоятельно в любое время суток на все доступные склады, куда мы возим ваши любимые товары. Если вам сложно разобраться - позвоните нам, хотя мы старались сделать сервис как 'раз-два-три'.", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Понятно", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func pressDataInfo(_ sender: Any) {
        
        let alert = UIAlertController(title: "Дни доставок", message:  "OZON: Вторник, Четверг, Суббота.\nWildBerries: Понедельник — Воскресенье\nЯндекс.Маркет: Понедельник — Воскресенье", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Понятно", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func pressBoxsInfo(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message:  "OZON — 175 руб./коробка\nWildBerries — 125 руб./коробка\nБеру! — 175 руб./коробка", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Понятно", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func pressPalletsInfo(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message:  "OZON — 1900 руб./паллет\nWildBerries — 1400 руб./паллет\nБеру! — 1900 руб./паллет", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Понятно", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func boxCountChange(_ sender: UISlider) {
        boxCountLabel.text = Int(sender.value).description
    }
    
    @IBAction func palletCountChange(_ sender: UISlider) {
        palletCountLabel.text = Int(sender.value).description
    }
    
    func setTitle(title: String) {
        navigationItem.title = "Оформление заказа"
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setDateDelegate() {
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone(secondsFromGMT: 10800)
        datePicker.addTarget(self, action: #selector(updateDateField), for: .valueChanged)
        
        dateField.inputView = datePicker
        
    }
    
    func setPlacesDelegate(locations: [Marketplaces.Point]) {
        
        placeDelegate = MarketplacePicker() { location in
            self.presenter?.selectDropPlace(place: location)
        }
    
        placeDelegate.locations = locations
        placePicker.delegate = placeDelegate
        placePicker.dataSource = placeDelegate
        
        dropField.inputView = placePicker
        
    }
    
    @objc func updateDateField() {
        setDate(text: DateFormatter().gmt3().dayMonthYear(date: datePicker.date))
    }
    
    func setDate(text: String) {
        dateField.text = text
    }
    
    @objc func pressAddress(_ sender: Any) {
        presenter?.pressAddress()
    }
    
    func setPickup(text: String) {
        pickupLabel.text = text
    }
    
    func setDrop(text: String) {
        dropField.text = text
    }
    
}
