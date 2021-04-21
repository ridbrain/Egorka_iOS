//
//  Extensions.swift
//  egorka
//
//  Created by Виталий Яковлев on 09.12.2020.
//

import UIKit
import Hero
import IQKeyboardManagerSwift
import MapKit

extension UINavigationBar {
    
    func installBlurEffect() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        blurView.layer.zPosition = -1
    }
    
}

extension UIView {

    func setShadow() {

        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.layer.shadowRadius = 4

    }
    
    func setBorder() {
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.colorGray.cgColor
        
    }
    
    func setCorner() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
    }

}

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        overrideInit()
    }
    
    func overrideInit() {
        
        layer.cornerRadius = 10
        
    }

}

class RoundedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        overrideInit()
    }
    
    func overrideInit() {
        
        layer.cornerRadius = 10
        
    }

}

class ShadowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        overrideInit()
    }
    
    func overrideInit() {
        
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.layer.shadowRadius = 4
        
    }

}

extension UIColor {

    public static var colorAccent: UIColor = UIColor(named: "ColorAccent")!
    public static var colorAccentLight: UIColor = UIColor(named: "ColorAccentLight")!
    public static var colorBlue: UIColor = UIColor(named: "ColorBlue")!
    public static var colorGray: UIColor = UIColor(named: "ColorGray")!
    public static var colorGreen: UIColor = UIColor(named: "ColorGreen")!
    public static var colorOrange: UIColor = UIColor(named: "ColorOrange")!
    public static var colorBackground: UIColor = UIColor(named: "ColorBackground")!
    
}

extension UIImage {
    
    public static var icFlag: UIImage = UIImage(named: "flag")!
    public static var icDown: UIImage = UIImage(named: "down")!
    
}

extension UINavigationController {
    
    func show(_ viewController: UIViewController, navigationAnimationType: HeroDefaultAnimationType = .autoReverse(presenting: .slide(direction: .leading))) {
        
        viewController.hero.isEnabled = true
        hero.isEnabled = true
        hero.navigationAnimationType = navigationAnimationType
        pushViewController(viewController, animated: true)
        
    }
    
}

extension UIViewController {
    
    func enableIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func disableIQKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
    }
    
    func enableHero() {
        hero.isEnabled = true
        navigationController?.hero.isEnabled = true
    }
    
    func disableHero() {
        navigationController?.hero.isEnabled = false
    }
    
}

extension DateFormatter {
    
    func gmt3() -> DateFormatter {
        self.timeZone = TimeZone(secondsFromGMT: 10800)
        self.locale = Locale(identifier: "en_US_POSIX")
        return self
    }
    
    func standardDate() -> DateFormatter {
        self.dateFormat = "dd MMMM yyyy"
        return self
    }
    
    func dayMonthYear(date: Date) -> String {
        self.dateFormat = "dd MMMM yyyy"
        return self.string(from: date)
    }
    
    func hoursMins(date: Date) -> String {
        self.dateFormat = "HH:mm"
        return self.string(from: date)
    }

    func iso(date: Date) -> String {
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return self.string(from: date)
    }
    
    func fromISO(date: String) -> Date? {
        self.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return self.date(from: date)
    }
    
}

class MyPoint: MKPointAnnotation {
    
    var type: LocationType
    
    init(type: LocationType) {
        self.type = type
        super.init()
    }
    
}
