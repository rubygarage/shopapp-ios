//
//  CategoryListUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CategoryListUseCaseMock: CategoryListUseCase {
    private let error = ContentError()
    
    var isCategoryCountLessThenConstant = true
    var isNeedToReturnError = false
    
    override func getCategoryList(paginationValue: Any?, _ callback: @escaping RepoCallback<[Category]>) {
        guard !isNeedToReturnError else {
            execute(callback: callback)
            
            return
        }

        let categoriesCount = isCategoryCountLessThenConstant ? 5 : 10
        var categories: [Category] = []
        
        for _ in 1...categoriesCount {
            let category = Category()
            category.paginationValue = "pagination value"
            categories.append(category)
        }
        
        execute(with: categories, callback: callback)
    }
    
    private func execute(with categories: [Category] = [], callback: @escaping RepoCallback<[Category]>) {
        isNeedToReturnError ? callback(nil, error) : callback(categories, nil)
    }
}
