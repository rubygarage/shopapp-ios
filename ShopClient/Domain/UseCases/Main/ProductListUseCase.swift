//
//  ProductUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

private let kPopuarSectionItemsMaxCount = 4

struct ProductListUseCase {
    public func getLastArrivalProductList(_ callback: @escaping RepoCallback<[Product]>) {
        Repository.shared.getProductList(sortBy: SortingValue.createdAt, reverse: true, callback: callback)
    }
    
    public func getPopularProductList(_ callback: @escaping RepoCallback<[Product]>) {
        Repository.shared.getProductList(perPage: kPopuarSectionItemsMaxCount, sortBy: SortingValue.popular, callback: callback)
    }
    
    public func getProductList(with paginationValue: Any?, sortingValue: SortingValue, reverse: Bool, _ callback: @escaping RepoCallback<[Product]>) {
        Repository.shared.getProductList(paginationValue: paginationValue, sortBy: sortingValue, reverse: reverse, callback: callback)
    }
    
    public func getProductList(with paginationValue: Any?, searchPhrase: String, _ callback: @escaping RepoCallback<[Product]>) {
        Repository.shared.searchProducts(paginationValue: paginationValue, searchQuery: searchPhrase, callback: callback)
    }
}
