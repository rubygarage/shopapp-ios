//
//  CheckoutUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct CheckoutUseCase {
    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        Repository.shared.getCheckout(with: checkoutId, callback: callback)
    }
    
    func updateCheckoutShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        Repository.shared.updateShippingAddress(with: checkoutId, address: address, callback: callback)
    }
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        Repository.shared.createCheckout(cartProducts: cartProducts, callback: callback)
    }
    
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>) {
        Repository.shared.pay(with: card, checkout: checkout, billingAddress: billingAddress, customerEmail: customerEmail, callback: callback)
    }
    
    func setupApplePay(with checkout: Checkout, callback: @escaping RepoCallback<Order>) {
        Repository.shared.setupApplePay(with: checkout, callback: callback)
    }
    
    func updateShippingRate(with checkoutId: String, rate: ShippingRate, callback: @escaping RepoCallback<Checkout>) {
        Repository.shared.updateCheckout(with: rate, checkoutId: checkoutId, callback: callback)
    }
}
