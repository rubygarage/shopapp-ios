//
//  SettingsViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class SettingsViewModel: BaseViewModel {
    private var updateCustomerUseCase: UpdateCustomerUseCase
    private let loginUseCase: LoginUseCase
    private let customerUseCase: CustomerUseCase
    
    var customer = Variable<Customer?>(nil)
    
    init(updateCustomerUseCase: UpdateCustomerUseCase, loginUseCase: LoginUseCase, customerUseCase: CustomerUseCase) {
        self.updateCustomerUseCase = updateCustomerUseCase
        self.loginUseCase = loginUseCase
        self.customerUseCase = customerUseCase
    }
    
    func loadCustomer() {
        loginUseCase.getLoginStatus { isLoggedIn in
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
        state.onNext(ViewState.make.loading())
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
        state.onNext(ViewState.make.loading(showHud: false))
        updateCustomerUseCase.updateCustomer(with: customer.promo) { [weak self] (customer, error) in
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
