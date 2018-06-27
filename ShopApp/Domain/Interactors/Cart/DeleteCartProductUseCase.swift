//
//  DeleteCartProductUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class DeleteCartProductUseCase {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }
    
    func deleteCartProduct(cartItemId: String, _ callback: @escaping RepoCallback<Bool>) {
        repository.deleteCartProduct(cartItemId: cartItemId, callback: callback)
    }
    
    func deleteCartProducts(cartItemIds: [String], callback: @escaping RepoCallback<Bool>) {
        repository.deleteCartProducts(cartItemIds: cartItemIds, callback: callback)
    }
}
