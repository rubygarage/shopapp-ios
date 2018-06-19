//
//  SplashViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 4/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class SplashViewModel: BaseViewModel {
    private let setupProviderUseCase: SetupProviderUseCase
    
    var providerDidSetup = PublishSubject<Void>()
    
    init(setupProviderUseCase: SetupProviderUseCase) {
        self.setupProviderUseCase = setupProviderUseCase
    }
    
    func setupProvider() {
        setupProviderUseCase.setupProvider { [weak self] (_, _) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.providerDidSetup.onNext()
        }
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        setupProvider()
    }
}
