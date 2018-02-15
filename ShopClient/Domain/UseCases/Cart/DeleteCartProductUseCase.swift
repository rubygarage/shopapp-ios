//
//  DeleteCartProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

struct DeleteCartProductUseCase {
    private let repository: CartRepository!

    init() {
        self.repository = nil
    }
    
    func deleteProductFromCart(productVariantId: String?, _ callback: @escaping RepoCallback<Bool>) {
        repository.deleteProductFromCart(with: productVariantId, callback: callback)
    }
}
