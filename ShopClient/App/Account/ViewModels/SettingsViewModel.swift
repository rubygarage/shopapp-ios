//
//  SettingsViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

class SettingsViewModel: BaseViewModel {
    private let loginUseCase = LoginUseCase()
    private let customerUseCase = CustomerUseCase()
    private let updateCustomUseCase = UpdateCustomUseCase()
    
    var customer = Variable<Customer?>(nil)
    
    // MARK: - Private
    
    private func getCustomer() {
        state.onNext(.loading(showHud: true))
        customerUseCase.getCustomer { [weak self] (customer, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let customer = customer {
                self?.customer.value = customer
                self?.state.onNext(.content)
            }
        }
    }
    
    // MARK: - Internal
    
    func loadCustomer() {
        loginUseCase.getLoginStatus { (isLoggedIn) in
            if isLoggedIn {
                getCustomer()
            }
        }
    }
    
    func updateCustomer() {
        state.onNext(.loading(showHud: false))
        updateCustomUseCase.updateCustomer(customer.value!) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let success = success, success == true {
                self?.state.onNext(.content)
            }
        }
    }
}
