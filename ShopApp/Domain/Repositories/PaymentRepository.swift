//
//  PaymentsRepositoryInterface.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol PaymentRepository {
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>)

    func getCheckout(id: String, callback: @escaping RepoCallback<Checkout>)

    func setShippingAddress(checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>)
    
    func getShippingRates(checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>)

    func setShippingRate(checkoutId: String, shippingRate: ShippingRate, callback: @escaping RepoCallback<Checkout>)

    func completeCheckout(checkout: Checkout, email: String, address: Address, card: CreditCard, callback: @escaping RepoCallback<Order>)

    func setupApplePay(checkout: Checkout, email: String, callback: @escaping RepoCallback<Order>)
}
