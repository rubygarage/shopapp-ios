//
//  CheckoutUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CheckoutUseCaseMock: CheckoutUseCase {
    var isNeedToReturnError = false
    var isPayWithCreditCardStarted = false
    var isSetupApplePayStarted = false
    var isUpdateCheckoutShippingAddressNeedToReturnError = false
    var isGetCheckoutNeedToReturnError = false
    var returnedOrder: Order?
    var returnedCheckout: Checkout?
    
    override func getCheckout(id: String, callback: @escaping RepoCallback<Checkout>) {
        isGetCheckoutNeedToReturnError ? callback(nil, RepoError()) : callback(returnedCheckout, nil)
    }
    
    override func setShippingAddress(checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        isUpdateCheckoutShippingAddressNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    override func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback(returnedCheckout, nil)
    }
    
    override func completeCheckout(checkout: Checkout, email: String, address: Address, card: CreditCard, callback: @escaping RepoCallback<Order>) {
        isPayWithCreditCardStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(returnedOrder, nil)
    }
    
    override func setupApplePay(checkout: Checkout, email: String, callback: @escaping RepoCallback<Order>) {
        isSetupApplePayStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(returnedOrder, nil)
    }
    
    override func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping RepoCallback<Checkout>) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback(returnedCheckout, nil)
    }
}
