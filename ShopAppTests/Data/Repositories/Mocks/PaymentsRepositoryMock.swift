//
//  PaymentsRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class PaymentsRepositoryMock: PaymentsRepository {
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>) {}
    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>) {}
    func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>) {}
    func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>) {}
    func updateCheckout(with rate: ShippingRate, checkoutId: String, callback: @escaping RepoCallback<Checkout>) {}
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, customerEmail: String, callback: @escaping RepoCallback<Order>) {}
    func setupApplePay(with checkout: Checkout, customerEmail: String, callback: @escaping RepoCallback<Order>) {}
    func getCountries(callback: @escaping RepoCallback<[Country]>) {}
}
