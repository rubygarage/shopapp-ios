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
    
    func deleteProductFromCart(productVariantId: String?, _ callback: @escaping RepoCallback<Bool>) {
        repository.deleteProductFromCart(with: productVariantId, callback: callback)
    }
    
    func deleteProductsFromCart(with productVariantIds: [String?], callback: @escaping RepoCallback<Bool>) {
        repository.deleteProductsFromCart(with: productVariantIds, callback: callback)
    }
}
