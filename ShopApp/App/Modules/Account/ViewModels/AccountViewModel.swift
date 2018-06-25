//
//  AccountViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/6/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class AccountViewModel: BaseViewModel {
    private let customerUseCase: CustomerUseCase
    private let signInUseCase: SignInUseCase
    private let signOutUseCase: SignOutUseCase
    private let shopUseCase: ShopUseCase
    
    var policies = Variable<[Policy]>([])
    var customer = Variable<Customer?>(nil)

    init(customerUseCase: CustomerUseCase, signInUseCase: SignInUseCase, signOutUseCase: SignOutUseCase, shopUseCase: ShopUseCase) {
        self.customerUseCase = customerUseCase
        self.signInUseCase = signInUseCase
        self.signOutUseCase = signOutUseCase
        self.shopUseCase = shopUseCase
    }
    
    func loadCustomer() {
        signInUseCase.isSignedIn({ [weak self] (isSignedIn, _) in
            guard let strongSelf = self else {
                return
            }

            if let isSignedIn = isSignedIn, isSignedIn {
                strongSelf.getCustomer()
            }
        })
    }
    
    func loadPolicies() {
        shopUseCase.getShop { [weak self] (shop, _) in
            guard let strongSelf = self, let shop = shop else {
                return
            }
            strongSelf.processResponse(with: shop)
        }
    }
    
    func logout() {
        signOutUseCase.signOut { [weak self] (_, error) in
            guard let strongSelf = self, error == nil else {
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
        if let privacyPolicy = shopItem.privacyPolicy, privacyPolicy.body.isEmpty == false {
            policiesItems.append(privacyPolicy)
        }
        if let refundPolicy = shopItem.refundPolicy, refundPolicy.body.isEmpty == false {
            policiesItems.append(refundPolicy)
        }
        if let termsOfService = shopItem.termsOfService, termsOfService.body.isEmpty == false {
            policiesItems.append(termsOfService)
        }
        policies.value = policiesItems
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        loadCustomer()
        loadPolicies()
    }
}
