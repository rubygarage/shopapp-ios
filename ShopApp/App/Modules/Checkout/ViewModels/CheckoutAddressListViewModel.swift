//
//  CheckoutAddressListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class CheckoutAddressListViewModel: BaseAddressListViewModel {
    private let checkoutUseCase = CheckoutUseCase()
    
    var didSelectBillingAddress = PublishSubject<Address>()
    var checkoutId: String!
    
    override func processDeleteAddressResponse(with isSelected: Bool, type: AddressListType) {
        if isSelected, let defaultAddress = customerDefaultAddress.value {
            setDefaultAddress(with: defaultAddress, type: type)
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
    
    private func setDefaultAddress(with address: Address, type: AddressListType) {
        if type == .shipping {
            updateCheckoutShippingAddress(with: address)
        } else {
            didSelectBillingAddress.onNext(address)
            loadCustomerAddresses(isTranslucentHud: true)
        }
    }
}
