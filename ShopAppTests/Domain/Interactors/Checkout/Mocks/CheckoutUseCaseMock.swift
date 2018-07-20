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
    
    override func getCheckout(id: String, callback: @escaping ApiCallback<Checkout>) {
        isGetCheckoutNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(returnedCheckout, nil)
    }
    
    override func setShippingAddress(checkoutId: String, address: Address, callback: @escaping ApiCallback<Bool>) {
        isUpdateCheckoutShippingAddressNeedToReturnError ? callback(false, ShopAppError.content(isNetworkError: false)) : callback(true, nil)
    }
    
    override func createCheckout(cartProducts: [CartProduct], callback: @escaping ApiCallback<Checkout>) {
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(returnedCheckout, nil)
    }
    
    override func completeCheckout(checkout: Checkout, email: String, address: Address, card: Card, callback: @escaping ApiCallback<Order>) {
        isPayWithCreditCardStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(returnedOrder, nil)
    }
    
    override func setupApplePay(checkout: Checkout, email: String, callback: @escaping ApiCallback<Order>) {
        isSetupApplePayStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(returnedOrder, nil)
    }
    
    override func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping ApiCallback<Checkout>) {
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(returnedCheckout, nil)
    }
}
