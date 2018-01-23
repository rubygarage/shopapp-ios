//
//  CheckoutUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct CheckoutUseCase {
    public func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {
        Repository.shared.getCheckout(with: checkoutId, callback: callback)
    }
    
    public func updateCheckoutShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        Repository.shared.updateShippingAddress(with: checkoutId, address: address, callback: callback)
    }
    
    public func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        Repository.shared.createCheckout(cartProducts: cartProducts, callback: callback)
    }
    
    public func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, callback: @escaping RepoCallback<Order>) {
        Repository.shared.pay(with: card, checkout: checkout, billingAddress: billingAddress, callback: callback)
    }
    
    public func setupApplePay(with checkout: Checkout, callback: @escaping RepoCallback<Bool>) {
        Repository.shared.setupApplePay(with: checkout, callback: callback)
    }
    
    public func updateShippingRate(with checkoutId: String, rate: ShippingRate, callback: @escaping RepoCallback<Checkout>) {
        Repository.shared.updateCheckout(with: rate, checkoutId: checkoutId, callback: callback)
    }
}
