//
//  PaymentsRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class PaymentRepositoryMock: PaymentRepository {
    var isNeedToReturnError = false
    var isCreateCheckoutStarted = false
    var isGetCheckoutStarted = false
    var isUpdateShippingAddressStarted = false
    var isGetShippingRatesStarted = false
    var isUpdateCheckoutStarted = false
    var isPayStarted = false
    var isSetupApplePayStarted = false
    var cartProducts: [CartProduct]?
    var checkoutId: String?
    var address: Address?
    var shippingRate: ShippingRate?
    var card: Card?
    var checkout: Checkout?
    var billingAddress: Address?
    var email: String?
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping ApiCallback<Checkout>) {
        isCreateCheckoutStarted = true
        
        self.cartProducts = cartProducts
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.checkoutWithShippingAddress, nil)
    }
    
    func getCheckout(id: String, callback: @escaping ApiCallback<Checkout>) {
        isGetCheckoutStarted = true
        
        checkoutId = id
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.checkoutWithShippingAddress, nil)
    }
    
    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping ApiCallback<Bool>) {
        isUpdateShippingAddressStarted = true
        
        self.checkoutId = checkoutId
        self.address = address
        
        isNeedToReturnError ? callback(false, ShopAppError.content(isNetworkError: false)) : callback(true, nil)
    }
    
    func getShippingRates(checkoutId: String, callback: @escaping ApiCallback<[ShippingRate]>) {
        isGetShippingRatesStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping ApiCallback<Checkout>) {
        isUpdateCheckoutStarted = true
        
        self.shippingRate = shippingRate
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.checkoutWithShippingAddress, nil)
    }
    
    func completeCheckout(checkout: Checkout, email: String, address: Address, card: Card, callback: @escaping ApiCallback<Order>) {
        isPayStarted = true
        
        self.card = card
        self.checkout = checkout
        self.billingAddress = address
        self.email = email
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.orderWithProducts, nil)
    }
    
    func setupApplePay(checkout: Checkout, email: String, callback: @escaping ApiCallback<Order>) {
        isSetupApplePayStarted = true
        
        self.checkout = checkout
        self.email = email
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.orderWithProducts, nil)
    }
}
