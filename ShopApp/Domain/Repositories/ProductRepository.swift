//
//  ProductRepositoryInterface.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol ProductRepository {
    func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping RepoCallback<[Product]>)

    func getProduct(id: String, callback: @escaping RepoCallback<Product>)

    func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping RepoCallback<[Product]>)

    func getProductVariants(ids: [String], callback: @escaping RepoCallback<[ProductVariant]>)
}
