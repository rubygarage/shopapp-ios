//
//  ProductRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ProductRepositoryMock: ProductRepository {
    func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, keyPhrase: String?, excludePhrase: String?, reverse: Bool, callback: @escaping RepoCallback<[Product]>) {}
    func getProduct(id: String, callback: @escaping RepoCallback<Product>) {}
    func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping RepoCallback<[Product]>) {}
}
