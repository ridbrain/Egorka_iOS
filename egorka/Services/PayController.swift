//
//  PayController.swift
//  egorka
//
//  Created by Vitaliy Yakovlev on 16.06.2021.
//

import TinkoffASDKUI
import TinkoffASDKCore
import PassKit

class PayController {
    
    static public func acquiringViewConfiguration(description: String, amount: Int) -> AcquiringViewConfiguration {
        
        let viewConfigration = AcquiringViewConfiguration.init()
        viewConfigration.fields = []
        viewConfigration.viewTitle = NSLocalizedString("Оплата", comment: "Оплата")
        
        let title = NSAttributedString.init(string: NSLocalizedString("Оплата", comment: "Оплата"), attributes: [.font: UIFont.boldSystemFont(ofSize: 22)])
        let amountString = Utils.formatAmount(NSDecimalNumber.init(floatLiteral: Double(amount)))
        let amountTitle = NSAttributedString.init(string: "\(NSLocalizedString("На сумму", comment: "на сумму")) \(amountString)", attributes: [.font : UIFont.systemFont(ofSize: 17)])
        viewConfigration.fields.append(AcquiringViewConfiguration.InfoFields.amount(title: title, amount: amountTitle))

        let productsDetatils = NSMutableAttributedString.init()
        productsDetatils.append(NSAttributedString.init(string: "Услуги\n", attributes: [.font : UIFont.systemFont(ofSize: 17)]))
        productsDetatils.append(NSAttributedString.init(string: description, attributes: [.font : UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor(red: 0.573, green: 0.6, blue: 0.635, alpha: 1)]))
        viewConfigration.fields.append(AcquiringViewConfiguration.InfoFields.detail(title: productsDetatils))

        viewConfigration.localizableInfo = AcquiringViewConfiguration.LocalizableInfo.init(lang: "ru")
        
        return viewConfigration
        
    }
    
    class Utils {
        
        private static let amountFormatter = NumberFormatter()
        
        static func formatAmount(_ value: NSDecimalNumber, fractionDigits: Int = 2, currency: String = "₽") -> String {
            amountFormatter.usesGroupingSeparator = true
            amountFormatter.groupingSize = 3
            amountFormatter.groupingSeparator = " "
            amountFormatter.alwaysShowsDecimalSeparator = false
            amountFormatter.decimalSeparator = ","
            amountFormatter.minimumFractionDigits = 0
            amountFormatter.maximumFractionDigits = fractionDigits
            
            return "\(amountFormatter.string(from: value) ?? "\(value)") \(currency)"
        }

    }
    
}
