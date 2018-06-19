//
//  ProductsUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ProductsUseCaseMock: ProductsUseCase {
    private let error = ContentError()
    
    var isProductCountLessThenConstant = true
    var isNeedToReturnEmptyProductList = false
    var isNeedToReturnError = false
    
    override func getLastArrivalProducts(_ callback: @escaping RepoCallback<[Product]>) {
        execute(with: [Product()], callback: callback)
    }
    
    override func getPopularProducts(_ callback: @escaping RepoCallback<[Product]>) {
        execute(with: [Product()], callback: callback)
    }
    
    override func getProducts(paginationValue: Any?, sortBy: SortType, keyword: String? = nil, excludeKeyword: String? = nil, _ callback: @escaping RepoCallback<[Product]>) {
        guard !isNeedToReturnError else {
            execute(callback: callback)
            
            return
        }
        
        let products = generatedProducts()
        execute(with: products, callback: callback)
    }
    
    override func getProducts(paginationValue: Any?, searchPhrase: String, _ callback: @escaping RepoCallback<[Product]>) {
        guard !isNeedToReturnError && !isNeedToReturnEmptyProductList else {
            execute(callback: callback)
            
            return
        }
        
        let products = generatedProducts()
        execute(with: products, callback: callback)
    }
    
    private func generatedProducts() -> [Product] {
        let productCount = isProductCountLessThenConstant ? 5 : 10
        var products: [Product] = []
        
        for _ in 1...productCount {
            let product = Product()
            product.paginationValue = "pagination value"
            products.append(product)
        }
        
        return products
    }
    
    private func execute(with products: [Product] = [], callback: @escaping RepoCallback<[Product]>) {
        isNeedToReturnError ? callback(nil, error) : callback(products, nil)
    }
}
