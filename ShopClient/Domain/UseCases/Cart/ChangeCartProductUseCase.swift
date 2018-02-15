//
//  ChangeCartProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

struct ChangeCartProductUseCase {
    private let repository: CartRepository!

    init() {
        self.repository = nil
    }

    func changeCartProductQuantity(productVariantId: String?, quantity: Int, _ callback: @escaping RepoCallback<CartProduct>) {
        repository.changeCartProductQuantity(with: productVariantId, quantity: quantity, callback: callback)
    }
}
