//
//  CheckoutAddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class CheckoutAddressFormViewModel: BaseViewModel {
    private let checkoutUseCase: CheckoutUseCase
    
    var updatedShippingAddress = PublishSubject<Void>()
    var filledBillingAddress = PublishSubject<Address>()
    var checkoutId: String!
    var addressType: AddressListType = .shipping

    init(checkoutUseCase: CheckoutUseCase) {
        self.checkoutUseCase = checkoutUseCase
    }
    
    func updateAddress(with address: Address) {
        if addressType == .shipping {
            updateCheckoutShippingAddress(with: address)
        } else {
            filledBillingAddress.onNext(address)
        }
    }
    
    private func updateCheckoutShippingAddress(with address: Address) {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        checkoutUseCase.updateCheckoutShippingAddress(with: checkoutId, address: address) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success, success == true {
                strongSelf.updatedShippingAddress.onNext()
            } else {
                strongSelf.state.onNext(.error(error: RepoError()))
            }
        }
    }
}
