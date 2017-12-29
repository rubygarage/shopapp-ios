//
//  ProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct ProductUseCase {
    public func getProduct(with id: String, _ callback: @escaping RepoCallback<Product>) {
        Repository.shared.getProduct(id: id, callback: callback)
    }
}
