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
    
    func deleteCartProduct(cartItemId: String, _ callback: @escaping ApiCallback<Void>) {
        repository.deleteCartProduct(cartItemId: cartItemId, callback: callback)
    }
}
