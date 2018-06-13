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
    var card: CreditCard?
    var checkout: Checkout?
    var billingAddress: Address?
    var email: String?
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        isCreateCheckoutStarted = true
        
        self.cartProducts = cartProducts
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func getCheckout(checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        isGetCheckoutStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        isUpdateShippingAddressStarted = true
        
        self.checkoutId = checkoutId
        self.address = address
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func getShippingRates(checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        isGetShippingRatesStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping RepoCallback<Checkout>) {
        isUpdateCheckoutStarted = true
        
        self.shippingRate = shippingRate
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func completeCheckout(checkout: Checkout, email: String, address: Address, card: CreditCard, callback: @escaping RepoCallback<Order>) {
        isPayStarted = true
        
        self.card = card
        self.checkout = checkout
        self.billingAddress = address
        self.email = email
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
    
    func setupApplePay(checkout: Checkout, email: String, callback: @escaping RepoCallback<Order>) {
        isSetupApplePayStarted = true
        
        self.checkout = checkout
        self.email = email
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
}
