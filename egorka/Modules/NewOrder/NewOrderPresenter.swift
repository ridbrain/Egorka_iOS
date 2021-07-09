//
//  NewOrderPresenter.swift
//  egorka
//
//  Created by Виталий Яковлев on 24.12.2020.
//

import UIKit
import TinkoffASDKUI
import TinkoffASDKCore
import WebKit

struct PriceTable {
    
    let total: Int
    let delivery: Int
    let ancillaries: Int
    let tcstax: Int
    
    init(price: Delivery.TotalPrice) {
        
        self.total = Int(Double(price.Total!) * 1.0269) / 100
        self.delivery = price.Total! / 100
        self.ancillaries = price.Ancillary! / 100
        self.tcstax = self.total - self.delivery
        
    }
    
}

class NewOrderPresenter: NewOrderPresenterProtocol {
    
    weak var view: NewOrderViewProtocol?
    var router: GeneralRouterProtocol?
    var delivery: Delivery!
    var order: Delivery?
    
    var bottomView: NewOrderBottomProtocol!
    var tcsSDK: AcquiringUISDK!
    
    required init(router: GeneralRouterProtocol, model: Delivery, view: NewOrderViewProtocol) {
        self.view = view
        self.delivery = model
        self.router = router
    }
    
    func viewDidLoad() {
        
        view?.setTitle(title: "Оформление заказа")
        view?.setTableViews()
        
        bottomView = NewOrderBottom()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let view = self.view?.view {
                self.bottomView.presentBottomView(view: view)
                self.bottomView.activeOrderButton(active: false)
            }
        }
        
    }
    
    func viewWillAppear() {
        
        updateArrays()
        updateOrder()
        
        view?.enableHero()
        view?.enableIQKeyboard()
        
    }
    
    func updateOrder() {
        
        delivery.Result?.Locations = delivery.Result?.Locations?.filter { $0.Point?.Code != nil }
        delivery.restoreIndex()
        
        Network.calculateDelivery(locations: delivery.getLoactionsParameters(), type: delivery.Type!) { delivery in
            
            self.delivery = delivery
            self.updateArrays()
            self.updateBottomView()
            
            guard let deliveryID = delivery.Result?.ID else { return }
            
            Network.bookDelivery(id: deliveryID) { order in
                
                guard let orderID = order.Result?.RecordNumber else { return }
                guard let orderPIN = order.Result?.RecordPIN else { return }
                
                Network.checkOrder(number: String(orderID), pin: String(orderPIN)) { status in
                    
                    guard let id = status.Result?.Invoices?[0].ID else { return }
                    guard let pin = status.Result?.Invoices?[0].PIN else { return }
                    
                    Network.getPaymentID(id: String(id), pin: String(pin)) { payment in
                        
//                        self.initTCS(payment: payment)
//                        self.initWebPay(payment: payment)
                        
                        print(payment)
                        print(payment.PaymentURL)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func initWebPay(payment: Payment) {
        
        let webView = WKWebView()
        webView.load(URLRequest(url: URL(string: payment.PaymentURL!)!))
        
        let vc = UIViewController()
        vc.view.addSubview(webView)
        
        view?.present(vc, animated: true, completion: nil)
        
    }
    
    func initTCS(payment: Payment) {
        
        let credentional = AcquiringSdkCredential(
            terminalKey: payment.TerminalKey!,
            password: "",
            publicKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv5yse9ka3ZQE0feuGtemYv3IqOlLck8zHUM7lTr0za6lXTszRSXfUO7jMb+L5C7e2QNFs+7sIX2OQJ6a+HG8kr+jwJ4tS3cVsWtd9NXpsU40PE4MeNr5RqiNXjcDxA+L4OsEm/BlyFOEOh2epGyYUd5/iO3OiQFRNicomT2saQYAeqIwuELPs1XpLk9HLx5qPbm8fRrQhjeUD5TLO8b+4yCnObe8vy/BMUwBfq+ieWADIjwWCMp2KTpMGLz48qnaD9kdrYJ0iyHqzb2mkDhdIzkim24A3lWoYitJCBrrB2xM05sm9+OdCI1f7nPNJbl5URHobSwR94IRGT7CJcUjvwIDAQAB")
        
        let acquiringSDKConfiguration = AcquiringSdkConfiguration(credential: credentional, server: .test)
        acquiringSDKConfiguration.logger = AcquiringLoggerDefault()
        
        tcsSDK = try! AcquiringUISDK.init(configuration: acquiringSDKConfiguration)
        
        let acquiringConfiguration = AcquiringConfiguration(paymentStage: .paymentId(Int64(payment.PaymentId!)!))
        let viewConfiguration = PayController.acquiringViewConfiguration(description: "Delivry", amount: payment.Amount! / 100)
       
        tcsSDK.presentPaymentView(on: view!,
                               paymentData: createPaymentData(payment: payment),
                               configuration: viewConfiguration,
                               acquiringConfiguration: acquiringConfiguration) { _ in }
        
    }
    
    func createPaymentData(payment: Payment) -> PaymentInitData {
        
        let amount = payment.Amount!
        
        var paymentData = PaymentInitData.init(
            amount: NSDecimalNumber.init(value: amount),
            orderId: payment.OrderId!,
            customerKey: UserData.getUserUUID())

        let receiptItems: [Item] = [Item.init(
                                        amount: Int64(amount),
                                        price: Int64(amount),
                                        name: "Delivry",
                                        tax: .none,
                                        paymentObject: .service)]
        
        paymentData.description = "Я.Красота"
        
        paymentData.receipt = Receipt.init(shopCode: nil,
                                           email: "ridbrain@ya.ru",
                                           taxation: .osn,
                                           phone: nil,
                                           items: receiptItems,
                                           agentData: nil,
                                           supplierInfo: nil,
                                           customer: UserData.getUserUUID(),
                                           customerInn: nil)
        
        return paymentData
        
    }
    
    func deleteLocation(routeOrder: Int) {
        
        delivery.Result?.Locations = delivery.Result?.Locations?.filter { $0.RouteOrder != routeOrder }
        updateOrder()
        
    }
    
    func updateBottomView() {
        
        guard let totalPrice = delivery.Result?.TotalPrice else { return }
        guard let deliveryType = delivery.Type else { return }
        
        bottomView.setInfoFields(type: TypeData(type: deliveryType), price: PriceTable(price: totalPrice))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.bottomView.transitionBottomView(index: 1)
        }
        
    }
    
    func updateArrays() {
        
        delivery.Result?.Locations = delivery.Result?.Locations?.filter { $0.Point?.Code != nil }
        
        guard let locations = delivery.Result?.Locations else { return }
        
        let pickups = locations.filter { $0.Type == .Pickup }
        let drops = locations.filter { $0.Type == .Drop }
        
        if locations.count > 2 {
            view?.updateTables(pickups: pickups, drops: drops, numState: .full)
        } else {
            view?.updateTables(pickups: pickups, drops: drops, numState: .lite)
        }
        
    }
    
    func viewWillDisappear() {
        
        bottomView.transitionBottomView(index: 0)
        bottomView.activeOrderButton(active: false)
        
        view?.disableHero()
        view?.disableIQKeyboard()
        
    }
    
    func openDetails(location: Location, index: Int) {
        
        router?.openLocationDetails(model: location, index: index)
        
    }
    
    func cancel() {
        
        view?.showWarning()
        
    }
    
    func newPickup() {
        
        guard let locations = delivery.Result?.Locations else { return }
        
        var pickups = locations
            .filter { $0.Type == .Pickup }
            .sorted { $0.RouteOrder! < $1.RouteOrder! }
        
        if let lastPickup = pickups.last {

            let newPickup = Location(suggestion: Dictionary.Suggestion(), type: .Pickup, routeOrder: lastPickup.RouteOrder! + 1)
            pickups.append(newPickup)
            
            let drops = locations.filter { $0.Type == .Drop }
            drops.forEach { location in location.RouteOrder = location.RouteOrder! + 1 }
            
            delivery.updateLocations(pickups: pickups, drops: drops)
            router?.openLocationDetails(model: newPickup, index: pickups.count - 1)

        }
        
    }
    
    func newDrop() {
        
        guard let locations = delivery.Result?.Locations else { return }
        
        var drops = locations
            .filter { $0.Type == .Drop }
            .sorted { $0.RouteOrder! < $1.RouteOrder! }
        
        if let lastDrop = drops.last {

            let newDrop = Location(suggestion: Dictionary.Suggestion(), type: .Drop, routeOrder: lastDrop.RouteOrder! + 1)
            drops.append(newDrop)
            
            delivery.updateLocations(pickups: locations.filter { $0.Type == .Pickup }, drops: drops)
            router?.openLocationDetails(model: newDrop, index: drops.count - 1)

        }
        
    }
    
}
