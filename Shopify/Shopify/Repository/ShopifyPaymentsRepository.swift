//
//  PaymentsRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

extension ShopifyRepository: PaymentsRepository {
    public func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        api.createCheckout(cartProducts: cartProducts, callback: callback)
    }
    
    public func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        api.getCheckout(with: checkoutId, callback: callback)
    }
    
    public func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        api.updateShippingAddress(with: checkoutId, address: address, callback: callback)
    }
    
    public func updateCustomerDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomerDefaultAddress(with: addressId, callback: callback)
    }
    
    public func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        api.updateCustomerAddress(with: address, callback: callback)
    }
    
    public func addCustomerAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        api.addCustomerAddress(with: address, callback: callback)
    }
    
    public func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        api.deleteCustomerAddress(with: addressId, callback: callback)
    }
    
    public func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        api.getShippingRates(with: checkoutId, callback: callback)
    }
    
    public func updateCheckout(with rate: ShippingRate, checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        api.updateCheckout(with: rate, checkoutId: checkoutId, callback: callback)
    }
    
    public func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        api.pay(with: card, checkout: checkout, billingAddress: billingAddress, customerEmail: customerEmail, callback: callback)
    }
    
    public func setupApplePay(with checkout: Checkout, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        api.setupApplePay(with: checkout, customerEmail: customerEmail, callback: callback)
    }
    
    public func getCountries(callback: @escaping RepoCallback<[Country]>) {
        api.getCountries(callback: callback)
    }
}
