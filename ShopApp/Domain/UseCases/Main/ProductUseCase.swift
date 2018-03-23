//
//  ProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ProductUseCase {
    private let repository: ProductRepository

    init(repository: ProductRepository) {
        self.repository = repository
    }

    func getProduct(with id: String, _ callback: @escaping RepoCallback<Product>) {
        repository.getProduct(id: id, callback: callback)
    }
}
