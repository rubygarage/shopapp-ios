//
//  CartProductsUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class CartProductsUseCase {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func getCartProducts(_ callback: @escaping RepoCallback<[CartProduct]>) {
        repository.getCartProducts(callback: callback)
    }
}
