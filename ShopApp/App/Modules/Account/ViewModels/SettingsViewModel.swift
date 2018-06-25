//
//  SettingsViewModel.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class SettingsViewModel: BaseViewModel {
    private var updateCustomerUseCase: UpdateCustomerUseCase
    private let signInUseCase: SignInUseCase
    private let customerUseCase: CustomerUseCase
    
    var customer = Variable<Customer?>(nil)
    
    init(updateCustomerUseCase: UpdateCustomerUseCase, signInUseCase: SignInUseCase, customerUseCase: CustomerUseCase) {
        self.updateCustomerUseCase = updateCustomerUseCase
        self.signInUseCase = signInUseCase
        self.customerUseCase = customerUseCase
    }
    
    func loadCustomer() {
        signInUseCase.isSignedIn { [weak self] (isSignedIn, _) in
            guard let strongSelf = self else {
                return
            }

            if let isSignedIn = isSignedIn, isSignedIn {
                strongSelf.getCustomer()
            }
        }
    }
    
    func setPromo(_ value: Bool) {
        guard customer.value != nil else {
            return
        }
        
        update(value)
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
    
    private func update(_ promo: Bool) {
        state.onNext(ViewState.make.loading(showHud: false))
        updateCustomerUseCase.updateCustomerSettings(isAcceptMarketing: promo) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.state.onNext(.content)
            }
        }
    }
}
