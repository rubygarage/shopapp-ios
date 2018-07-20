//
//  ShopAppPaymentsRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ShopAppPaymentRepository: PaymentRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func createCheckout(cartProducts: [CartProduct], callback: @escaping ApiCallback<Checkout>) {
        api.createCheckout(cartProducts: cartProducts, callback: callback)
    }
    
    func getCheckout(id: String, callback: @escaping ApiCallback<Checkout>) {
        api.getCheckout(id: id, callback: callback)
    }
    
    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping ApiCallback<Bool>) {
        api.setShippingAddress(checkoutId: checkoutId, address: address, callback: callback)
    }
    
    func getShippingRates(checkoutId: String, callback: @escaping ApiCallback<[ShippingRate]>) {
        api.getShippingRates(checkoutId: checkoutId, callback: callback)
    }
    
    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping ApiCallback<Checkout>) {
        api.setShippingRate(checkoutId: checkoutId, shippingRate: shippingRate, callback: callback)
    }

    func completeCheckout(checkout: Checkout, email: String, address: Address, card: Card, callback: @escaping ApiCallback<Order>) {
        api.completeCheckout(checkout: checkout, email: email, address: address, card: card, callback: callback)
    }
    
    func setupApplePay(checkout: Checkout, email: String, callback: @escaping ApiCallback<Order>) {
        api.setupApplePay(checkout: checkout, email: email, callback: callback)
    }
}
