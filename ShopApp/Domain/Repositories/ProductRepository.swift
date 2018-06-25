//
//  ProductRepositoryInterface.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol ProductRepository {
    func getProducts(perPage: Int, paginationValue: Any?, sortBy: SortType?, keyword: String?, excludeKeyword: String?, callback: @escaping ApiCallback<[Product]>)

    func getProduct(id: String, callback: @escaping ApiCallback<Product>)

    func searchProducts(perPage: Int, paginationValue: Any?, query: String, callback: @escaping ApiCallback<[Product]>)

    func getProductVariants(ids: [String], callback: @escaping ApiCallback<[ProductVariant]>)
}
