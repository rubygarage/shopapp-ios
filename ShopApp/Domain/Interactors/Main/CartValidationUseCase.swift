//
//  CartValidationUseCase.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 4/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class CartValidationUseCase {
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    func getProductVariants(ids: [String], _ callback: @escaping RepoCallback<[ProductVariant]>) {
        repository.getProductVariants(ids: ids, callback: callback)
    }
}
