//
//  AddCartProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class AddCartProductUseCase {
    private lazy var repository = AppDelegate.getCartRepository()

    func addCartProduct(_ cartProduct: CartProduct, _ callback: @escaping RepoCallback<CartProduct>) {
        repository.addCartProduct(cartProduct: cartProduct, callback: callback)
    }
}
