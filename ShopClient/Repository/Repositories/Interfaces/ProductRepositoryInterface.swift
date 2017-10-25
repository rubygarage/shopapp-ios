//
//  ProductRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol ProductRepositoryInterface {
    func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Product]>)
    func getProduct(id: String, options: [SelectedOption], callback: @escaping RepoCallback<Product>)
    func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping RepoCallback<[Product]>)
}
