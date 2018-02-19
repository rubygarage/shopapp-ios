//
//  DeleteCartProductsUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class DeleteCartProductsUseCase {
    private lazy var repository = AppDelegate.getCartRepository()

    func clearCart(_ callback: @escaping RepoCallback<Bool>) {
        repository.deleteAllProductsFromCart(with: callback)
    }
}
