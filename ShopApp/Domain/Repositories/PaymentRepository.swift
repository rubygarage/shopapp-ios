//
//  PaymentsRepositoryInterface.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol PaymentRepository {
    func createCheckout(cartProducts: [CartProduct], callback: @escaping ApiCallback<Checkout>)

    func getCheckout(id: String, callback: @escaping ApiCallback<Checkout>)

    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping ApiCallback<Bool>)
    
    func getShippingRates(checkoutId: String, callback: @escaping ApiCallback<[ShippingRate]>)

    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping ApiCallback<Checkout>)

    func completeCheckout(checkout: Checkout, email: String, address: Address, card: Card, callback: @escaping ApiCallback<Order>)

    func setupApplePay(checkout: Checkout, email: String, callback: @escaping ApiCallback<Order>)
}
