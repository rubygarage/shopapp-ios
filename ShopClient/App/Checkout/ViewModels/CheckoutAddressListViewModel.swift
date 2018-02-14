//
//  CheckoutAddressListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class CheckoutAddressListViewModel: AddressListViewModel {
    override func processDeleteAddressResponse(with isSelected: Bool) {
        if isSelected, let defaultAddress = customerDefaultAddress.value {
            updateCheckoutShippingAddress(with: defaultAddress)
        } else {
            loadCustomerAddresses(isTranslucentHud: true)
        }
    }
}
