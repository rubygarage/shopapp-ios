//
//  ProductListUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ProductListUseCaseMock: ProductListUseCase {
    var isNeedToReturnError = false
    
    override func getLastArrivalProductList(_ callback: @escaping RepoCallback<[Product]>) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback([Product()], nil)
    }
    
    override func getPopularProductList(_ callback: @escaping RepoCallback<[Product]>) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback([Product()], nil)
    }
    
    override func getProductList(with paginationValue: Any?, sortingValue: SortingValue, keyPhrase: String? = nil, excludePhrase: String? = nil, reverse: Bool, _ callback: @escaping RepoCallback<[Product]>) {}
    
    override func getProductList(with paginationValue: Any?, searchPhrase: String, _ callback: @escaping RepoCallback<[Product]>) {}
}
