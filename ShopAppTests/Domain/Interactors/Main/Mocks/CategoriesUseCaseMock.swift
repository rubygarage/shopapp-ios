//
//  CategoriesUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CategoriesUseCaseMock: CategoriesUseCase {
    private let error = ShopAppError.content(isNetworkError: false)
    
    var isCategoryCountLessThenConstant = true
    var isNeedToReturnError = false
    
    override func getCategoryList(paginationValue: Any?, _ callback: @escaping ApiCallback<[Category]>) {
        guard !isNeedToReturnError else {
            execute(callback: callback)
            
            return
        }

        let categoriesCount = isCategoryCountLessThenConstant ? 5 : 10
        var categories: [Category] = []
        
        for _ in 1...categoriesCount {
            categories.append(TestHelper.categoryWithFiveProducts)
        }
        
        execute(with: categories, callback: callback)
    }
    
    private func execute(with categories: [Category] = [], callback: @escaping ApiCallback<[Category]>) {
        isNeedToReturnError ? callback(nil, error) : callback(categories, nil)
    }
}
