//
//  ChangeCartProductUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class ChangeCartProductUseCase {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func changeCartProductQuantity(productVariantId: String?, quantity: Int, _ callback: @escaping RepoCallback<Bool>) {
        repository.changeCartProductQuantity(with: productVariantId, quantity: quantity, callback: callback)
    }
}
