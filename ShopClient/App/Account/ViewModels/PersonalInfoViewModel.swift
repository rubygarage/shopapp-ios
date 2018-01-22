//
//  PersonalInfoViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

class PersonalInfoViewModel: BaseViewModel {
    private let customerUseCase = CustomerUseCase()
    private let loginUseCase = LoginUseCase()
    
    var customer = Variable<Customer?>(nil)
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var emailText = Variable<String>("")
    var phoneText = Variable<String>("")
    var emailErrorMessage = PublishSubject<String>()
    
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
}
