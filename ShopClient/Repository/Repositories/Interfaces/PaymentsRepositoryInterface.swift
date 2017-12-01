//
//  PaymentsRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol PaymentsRepositoryInterface {
    func getCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>)
    func getShippingRates(with checkout: Checkout, address: Address, callback: @escaping RepoCallback<[ShippingRate]>)
    func updateCheckout(with rate: ShippingRate, checkout: Checkout, callback: @escaping RepoCallback<Checkout>)
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, callback: @escaping RepoCallback<Bool>)
}
