//
//  ProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

struct ProductUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func getProduct(with id: String, _ callback: @escaping RepoCallback<Product>) {
        repository.getProduct(id: id, callback: callback)
    }
}
