//
//  CheckoutAddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CheckoutAddressFormDelegate: class {
    func viewModelDidUpdateShippingAddress(_ model: CheckoutAddressFormViewModel)
    func viewModel(_ model: CheckoutAddressFormViewModel, didFill billingAddress: Address)
}

class CheckoutAddressFormViewModel: BaseViewModel {
    private let checkoutUseCase = CheckoutUseCase()
    
    var checkoutId: String!
    var addressType: AddressListType = .shipping
    
    weak var delegate: CheckoutAddressFormDelegate?
    
    func updateAddress(with address: Address) {
        if addressType == .shipping {
            updateCheckoutShippingAddress(with: address)
        } else {
            delegate?.viewModel(self, didFill: address)
        }
    }
    
    private func updateCheckoutShippingAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        checkoutUseCase.updateCheckoutShippingAddress(with: checkoutId, address: address) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success, success == true {
                strongSelf.delegate?.viewModelDidUpdateShippingAddress(strongSelf)
            } else {
                strongSelf.state.onNext(.error(error: RepoError()))
            }
        }
    }
}
