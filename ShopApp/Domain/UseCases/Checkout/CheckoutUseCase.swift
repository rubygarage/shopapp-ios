//
//  CheckoutUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class CheckoutUseCase {
    private lazy var repository = AppDelegate.getRepository()

    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        repository.getCheckout(with: checkoutId, callback: callback)
    }
    
    func updateCheckoutShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        repository.updateShippingAddress(with: checkoutId, address: address, callback: callback)
    }
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        repository.createCheckout(cartProducts: cartProducts, callback: callback)
    }
    
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        repository.pay(with: card, checkout: checkout, billingAddress: billingAddress, customerEmail: customerEmail, callback: callback)
    }
    
    func setupApplePay(with checkout: Checkout, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        repository.setupApplePay(with: checkout, customerEmail: customerEmail, callback: callback)
    }
    
    func updateShippingRate(with checkoutId: String, rate: ShippingRate, callback: @escaping RepoCallback<Checkout>) {
        repository.updateCheckout(with: rate, checkoutId: checkoutId, callback: callback)
    }
}
