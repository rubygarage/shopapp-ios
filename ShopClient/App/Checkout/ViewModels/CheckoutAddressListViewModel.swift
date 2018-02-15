//
//  CheckoutAddressListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CheckoutAddressListViewModel: AddressListViewModel {
    private let checkoutUseCase = CheckoutUseCase()
    
    var checkoutId: String!
    
    override func processDeleteAddressResponse(with isSelected: Bool) {
        if isSelected, let defaultAddress = customerDefaultAddress.value {
            updateCheckoutShippingAddress(with: defaultAddress)
        } else {
            loadCustomerAddresses(isTranslucentHud: true)
        }
    }
    
    func updateCheckoutShippingAddress(with address: Address) {
        state.onNext(ViewState.make.loading())
        checkoutUseCase.updateCheckoutShippingAddress(with: checkoutId, address: address) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success, success == true {
                strongSelf.selectedAddress = address
                strongSelf.didSelectAddress.onNext(address)
                strongSelf.loadCustomerAddresses(isTranslucentHud: true)
            } else {
                strongSelf.state.onNext(.error(error: RepoError()))
            }
        }
    }
}
