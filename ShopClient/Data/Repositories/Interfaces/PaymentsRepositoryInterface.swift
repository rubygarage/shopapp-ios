//
//  PaymentsRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol PaymentsRepositoryInterface {
    func createCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>)
    func getCheckout(with checkoutId: String, callback: @escaping RepoCallback<Checkout>)
    func updateShippingAddress(with checkoutId: String, address: Address, callback: @escaping RepoCallback<Bool>)
    func updateCustomerDefaultAddress(with address: Address, callback: @escaping RepoCallback<Bool>)
    func getShippingRates(with checkoutId: String, callback: @escaping RepoCallback<[ShippingRate]>)
    func updateCheckout(with rate: ShippingRate, checkout: Checkout, callback: @escaping RepoCallback<Checkout>)
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, callback: @escaping RepoCallback<Bool>)
}
