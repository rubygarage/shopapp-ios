//
//  AccountViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/6/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class AccountViewModel: BaseViewModel {
    private let customerUseCase = CustomerUseCase()
    private let loginUseCase = LoginUseCase()
    private let logoutUseCase = LogoutUseCase()
    private let shopUseCase = ShopUseCase()
    
    var policies = Variable<[Policy]>([])
    var customer = Variable<Customer?>(nil)
    
    func loadCustomer() {
        loginUseCase.getLoginStatus { isLoggedIn in
            if isLoggedIn {
                getCustomer()
            }
        }
    }
    
    func loadPolicies() {
        shopUseCase.getShop { [weak self] shop in
            guard let strongSelf = self else {
                return
            }
            strongSelf.processResponse(with: shop)
        }
    }
    
    func logout() {
        logoutUseCase.logout { [weak self] isLoggedOut in
            guard let strongSelf = self, isLoggedOut else {
                return
            }
            strongSelf.customer.value = nil
        }
    }
    
    private func getCustomer() {
        let showHud = customer.value == nil
        state.onNext(ViewState.make.loading(showHud: showHud))
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
    
    private func processResponse(with shopItem: Shop) {
        var policiesItems: [Policy] = []
        if let privacyPolicy = shopItem.privacyPolicy, privacyPolicy.body?.isEmpty == false {
            policiesItems.append(privacyPolicy)
        }
        if let refundPolicy = shopItem.refundPolicy, refundPolicy.body?.isEmpty == false {
            policiesItems.append(refundPolicy)
        }
        if let termsOfService = shopItem.termsOfService, termsOfService.body?.isEmpty == false {
            policiesItems.append(termsOfService)
        }
        policies.value = policiesItems
    }
}
