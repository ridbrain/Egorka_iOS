//
//  TestViewController.swift
//  egorka
//
//  Created by Виталий Яковлев on 18.12.2020.
//

import UIKit
import Hero

class SplashViewController: UIViewController {
    
    var router: GeneralRouterProtocol?

    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableHero()
        
        DispatchQueue.global(qos: .background).async {
            usleep(5000)
            DispatchQueue.main.async { [self] in
                next()
            }
        }
        
    }
    
    func next() {
        router?.pushMainView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableHero()
    }
    
}
