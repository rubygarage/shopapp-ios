//
//  DeleteCartProductsUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

struct DeleteCartProductsUseCase {
    private let repository: CartRepository!

    init() {
        self.repository = nil
    }

    func clearCart(_ callback: @escaping RepoCallback<Bool>) {
        repository.deleteAllProductsFromCart(with: callback)
    }
}
