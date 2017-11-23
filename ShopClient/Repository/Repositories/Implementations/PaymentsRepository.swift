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
    
    func payByCard(with card: CreditCard, url: String, callback: @escaping RepoCallback<String>) {
        APICore?.payByCard(with: card, url: url, callback: callback)
    }
}
