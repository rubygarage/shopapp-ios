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
    
    func loadCustomer() {
        loginUseCase.getLoginStatus { (isLoggedIn) in
            if isLoggedIn {
                getCustomer()
            }
        }
    }
    
    func setPromo(_ value: Bool) {
        guard let customer = customer.value else {
            return
        }
        
        customer.promo = value
        update(customer)
    }
    
    private func getCustomer() {
        state.onNext(.loading(showHud: true))
        customerUseCase.getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let customer = customer {
                strongSelf.customer.value = customer
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    private func update(_ customer: Customer) {
        state.onNext(.loading(showHud: false))
        updateCustomUseCase.updateCustomer(with: customer.promo) { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if customer != nil {
                strongSelf.state.onNext(.content)
            }
        }
    }
}
