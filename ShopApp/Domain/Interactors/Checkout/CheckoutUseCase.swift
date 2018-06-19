//
//  CheckoutUseCase.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 1/10/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class CheckoutUseCase {
    private let repository: PaymentRepository

    init(repository: PaymentRepository) {
        self.repository = repository
    }

    func getCheckout(id: String, callback: @escaping RepoCallback<Checkout>) {
        repository.getCheckout(id: id, callback: callback)
    }
    
    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {
        repository.setShippingAddress(checkoutId: checkoutId, address: address, callback: callback)
    }
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {
        repository.createCheckout(cartProducts: cartProducts, callback: callback)
    }
    
    func completeCheckout(checkout: Checkout, email: String, address: Address, card: CreditCard, callback: @escaping RepoCallback<Order>) {
        repository.completeCheckout(checkout: checkout, email: email, address: address, card: card, callback: callback)
    }
    
    func setupApplePay(checkout: Checkout, email: String, callback: @escaping RepoCallback<Order>) {
        repository.setupApplePay(checkout: checkout, email: email, callback: callback)
    }
    
    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping RepoCallback<Checkout>) {
        repository.setShippingRate(checkoutId: checkoutId, shippingRate: shippingRate, callback: callback)
    }
}
