//
//  CheckoutAddressFormControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CheckoutAddressFormControllerDelegateMock: CheckoutAddressFormControllerDelegate {
    var controller: CheckoutAddressFormViewController?
    var billingAddress: Address?
    
    // MARK: - CheckoutAddressFormControllerDelegate
    
    func viewControllerDidUpdateShippingAddress(_ controller: CheckoutAddressFormViewController) {
        self.controller = controller
    }
    
    func viewController(_ controller: CheckoutAddressFormViewController, didFill billingAddress: Address) {
        self.controller = controller
        self.billingAddress = billingAddress
    }
}
