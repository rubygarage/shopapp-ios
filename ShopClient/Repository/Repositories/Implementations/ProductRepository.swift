//
//  ProductRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

extension RepositoryRepo {
    func getProductList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping RepoCallback<[Product]>) {
        APICore?.getProductList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
    
    func getProduct(id: String, options: [SelectedOption], callback: @escaping RepoCallback<Product>) {
        APICore?.getProduct(id: id, options: options, callback: callback)
    }
    
    func searchProducts(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, searchQuery: String, callback: @escaping RepoCallback<[Product]>) {
        APICore?.searchProducts(perPage: perPage, paginationValue: paginationValue, searchQuery: searchQuery, callback: callback)
    }
}
