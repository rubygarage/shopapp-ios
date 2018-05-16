//
//  ProductRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ProductRepositoryMock: ProductRepository {
    var isNeedToReturnError = false
    var isGetProductListStarted = false
    var isGetProductStarted = false
    var isSearchProductsStarted = false
    var isGetProductVariantListStarted = false
    var perPage: Int?
    var paginationValue: String?
    var sortBy: SortingValue?
    var keyPhrase: String?
    var excludePhrase: String?
    var reverse: Bool?
    var id: String?
    var searchQuery: String?
    var ids: [String]?
    
    func getProductList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, keyPhrase: String?, excludePhrase: String?, reverse: Bool, callback: @escaping RepoCallback<[Product]>) {
        isGetProductListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.keyPhrase = keyPhrase
        self.excludePhrase = excludePhrase
        self.reverse = reverse
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getProduct(id: String, callback: @escaping RepoCallback<Product>) {
        isGetProductStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Product(), nil)
    }
    
    func searchProducts(perPage: Int, paginationValue: Any?, searchQuery: String, callback: @escaping RepoCallback<[Product]>) {
        isSearchProductsStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.searchQuery = searchQuery
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getProductVariantList(ids: [String], callback: @escaping RepoCallback<[ProductVariant]>) {
        isGetProductVariantListStarted = true
        
        self.ids = ids
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
}
