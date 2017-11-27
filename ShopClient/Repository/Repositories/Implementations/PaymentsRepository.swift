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
    
    func getShipingRates(with checkout: Checkout, address: Address, callback: @escaping RepoCallback<[ShipingRate]>) {
        APICore?.getShipingRates(with: checkout, address: address, callback: callback)
    }
    
    func updateCheckout(with rate: ShipingRate, checkout: Checkout, callback: @escaping RepoCallback<Bool>) {
        APICore?.updateCheckout(with: rate, checkout: checkout, callback: callback)
    }
    
    func pay(with card: CreditCard, checkout: Checkout, billingAddress: Address, callback: @escaping RepoCallback<Bool>) {
        APICore?.pay(with: card, checkout: checkout, billingAddress: billingAddress, callback: callback)
    }
}
