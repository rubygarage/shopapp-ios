//
//  CheckoutRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol CheckoutRepositoryInterface {
    func getCheckout(cartProducts: [CartProduct], callback: @escaping (Bool?, RepoError?) -> ())
}
