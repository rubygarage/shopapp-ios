//
//  CategoryUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CategoryUseCaseMock: CategoryUseCase {
    private let error = ContentError()
    
    var isProductCountLessThenConstant = true
    var isNeedToReturnError = false
    
    override func getCategory(with id: String, paginationValue: Any?, sortingValue: SortingValue, reverse: Bool, _ callback: @escaping RepoCallback<Category>) {
        guard !isNeedToReturnError else {
            execute(callback: callback)
            
            return
        }
        
        let productCount = isProductCountLessThenConstant ? 5 : 10
        var products: [Product] = []
        
        for _ in 1...productCount {
            let product = Product()
            product.paginationValue = "pagination value"
            products.append(product)
        }
        
        let category = Category()
        category.products = products
        
        execute(with: category, callback: callback)
    }
    
    private func execute(with category: Category? = nil, callback: @escaping RepoCallback<Category>) {
        isNeedToReturnError ? callback(nil, error) : callback(category, nil)
    }
}
