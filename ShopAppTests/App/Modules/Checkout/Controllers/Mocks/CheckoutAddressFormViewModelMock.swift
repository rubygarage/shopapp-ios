//
//  CheckoutAddressFormViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CheckoutAddressFormViewModelMock: CheckoutAddressFormViewModel {
    var returnedAddress: Address!
    
    func updateShippingAddress() {
        updatedShippingAddress.onNext()
    }
    
    func updateBillingAddress() {
        filledBillingAddress.onNext(returnedAddress)
    }
}
