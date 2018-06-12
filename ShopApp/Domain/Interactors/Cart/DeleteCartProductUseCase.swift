//
//  DeleteCartProductUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class DeleteCartProductUseCase {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }
    
    func deleteCartProduct(productVariantId: String, _ callback: @escaping RepoCallback<Bool>) {
        repository.deleteCartProduct(productVariantId: productVariantId, callback: callback)
    }
    
    func deleteCartProducts(productVariantIds: [String], callback: @escaping RepoCallback<Bool>) {
        repository.deleteCartProducts(productVariantIds: productVariantIds, callback: callback)
    }
}
