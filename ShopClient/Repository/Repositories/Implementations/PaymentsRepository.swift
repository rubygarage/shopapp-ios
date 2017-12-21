//
//  PaymentsRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

extension Repository {
    func getCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        APICore?.getCheckout(cartProducts: cartProducts, callback: callback)
    }
    
    func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        APICore?.updateShippingAddress(with: checkoutId, address: address, callback: callback)
    }
    
    func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {
        APICore?.getShippingRates(with: checkoutId, callback: callback)
    }
    
    func updateCheckout(with rate: ShippingRate, checkout: Checkout, callback: @escaping RepoCallback<Checkout>) {
        APICore?.updateCheckout(with: rate, checkout: checkout, callback: callback)
    }
    
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, callback: @escaping RepoCallback<Bool>) {
        APICore?.pay(with: card, checkout: checkout, billingAddress: billingAddress, callback: callback)
    }
}
