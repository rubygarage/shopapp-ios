//
//  ShopAppPaymentsRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ShopAppPaymentsRepository: PaymentsRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        api.createCheckout(cartProducts: cartProducts, callback: callback)
    }
    
    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        api.getCheckout(with: checkoutId, callback: callback)
    }
    
    func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        api.updateShippingAddress(with: checkoutId, address: address, callback: callback)
    }
    
    func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        api.getShippingRates(with: checkoutId, callback: callback)
    }
    
    func updateCheckout(with rate: ShippingRate, checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        api.updateCheckout(with: rate, checkoutId: checkoutId, callback: callback)
    }
    
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        api.pay(with: card, checkout: checkout, billingAddress: billingAddress, customerEmail: customerEmail, callback: callback)
    }
    
    func setupApplePay(with checkout: Checkout, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        api.setupApplePay(with: checkout, customerEmail: customerEmail, callback: callback)
    }
    
    func getCountries(callback: @escaping RepoCallback<[Country]>) {
        api.getCountries(callback: callback)
    }
}
