//
//  AddCartProductUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class AddCartProductUseCase {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func addCartProduct(_ cartProduct: CartProduct, _ callback: @escaping RepoCallback<Bool>) {
        repository.addCartProduct(cartProduct: cartProduct, callback: callback)
    }
}
