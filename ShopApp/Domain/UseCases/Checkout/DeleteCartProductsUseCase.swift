//
//  DeleteCartProductsUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class DeleteCartProductsUseCase {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func clearCart(_ callback: @escaping RepoCallback<Bool>) {
        repository.deleteAllProductsFromCart(with: callback)
    }
}
