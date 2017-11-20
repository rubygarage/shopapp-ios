//
//  CheckoutRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

extension Repository {
    func getCheckout(cartProducts: [CartProduct], callback: @escaping (Bool?, RepoError?) -> ()) {
        APICore?.getCheckout(cartProducts: cartProducts, callback: callback)
    }
}
