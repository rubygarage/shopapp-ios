//
//  PaymentsRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol PaymentsRepositoryInterface {
    func getCheckout(cartProducts: [CartProduct], callback: @escaping RepoCallback<Checkout>)
    func payByCard(with card: CreditCard, checkout: Checkout, callback: @escaping RepoCallback<Bool>)
    func getShipingRates(with checkout: Checkout, address: Address, callback: @escaping RepoCallback<[ShipingRate]>)
}
