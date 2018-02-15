//
//  CartProductListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

struct CartProductListUseCase {
    private let repository: CartRepository!

    init() {
        self.repository = nil
    }

    func getCartProductList(_ callback: @escaping RepoCallback<[CartProduct]>) {
        repository.getCartProductList(callback: callback)
    }
}
