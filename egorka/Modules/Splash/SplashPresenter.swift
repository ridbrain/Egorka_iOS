//
//  SplashPresenter.swift
//  egorka
//
//  Created by Виталий Яковлев on 22.12.2020.
//

import UIKit

class SplashPresenter: SplashPresenterProtocol {
    
    weak var view: SplashViewProtocol?
    var router: GeneralRouterProtocol?
    
    
    required init(router: GeneralRouterProtocol, view: SplashViewProtocol) {
        self.view = view
        self.router = router
    }
    
    func viewWillAppear() {
        
        view?.enableHero()
        
        if UserData.isUserUUID() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.router?.openMainView()
            }

        } else {

            Network.getUUID { user in

                UserData.setUserUUID(uuid: user.ID!)
                UserData.setUserSecure(seceure: user.Secure!)

                self.router?.openMainView()

            }

        }
        
    }
    
    func viewWillDisappear() {
        view?.disableHero()
    }
}
