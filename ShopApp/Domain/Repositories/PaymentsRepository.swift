//
//  PaymentsRepositoryInterface.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol PaymentsRepository {
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>)
    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>)
    func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>)
    
    func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>)
    func updateCheckout(with rate: ShippingRate, checkoutId: String, callback: @escaping RepoCallback<Checkout>)
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>)
    func setupApplePay(with checkout: Checkout, customerEmail: String, callback: @escaping RepoCallback<Order>)
    func getCountries(callback: @escaping RepoCallback<[Country]>)
}
