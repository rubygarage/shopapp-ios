//
//  CartProductListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class CartProductListUseCase {
    private lazy var repository = AppDelegate.getCartRepository()

    func getCartProductList(_ callback: @escaping RepoCallback<[CartProduct]>) {
        repository.getCartProductList(callback: callback)
    }
}
