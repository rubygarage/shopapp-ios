//
//  PaymentsRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class PaymentsRepositoryMock: PaymentsRepository {
    var isNeedToReturnError = false
    var isCreateCheckoutStarted = false
    var isGetCheckoutStarted = false
    var isUpdateShippingAddressStarted = false
    var isGetShippingRatesStarted = false
    var isUpdateCheckoutStarted = false
    var isPayStarted = false
    var isSetupApplePayStarted = false
    var isGetCountriesStarted = false
    var cartProducts: [CartProduct]?
    var checkoutId: String?
    var address: Address?
    var rate: ShippingRate?
    var card: CreditCard?
    var checkout: Checkout?
    var billingAddress: Address?
    var customerEmail: String?
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        isCreateCheckoutStarted = true
        
        self.cartProducts = cartProducts
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        isGetCheckoutStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        isUpdateShippingAddressStarted = true
        
        self.checkoutId = checkoutId
        self.address = address
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        isGetShippingRatesStarted = true
        
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func updateCheckout(with rate: ShippingRate, checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        isUpdateCheckoutStarted = true
        
        self.rate = rate
        self.checkoutId = checkoutId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Checkout(), nil)
    }
    
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        isPayStarted = true
        
        self.card = card
        self.checkout = checkout
        self.billingAddress = billingAddress
        self.customerEmail = customerEmail
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
    
    func setupApplePay(with checkout: Checkout, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        isSetupApplePayStarted = true
        
        self.checkout = checkout
        self.customerEmail = customerEmail
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
    
    func getCountries(callback: @escaping RepoCallback<[Country]>) {
        isGetCountriesStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
}
