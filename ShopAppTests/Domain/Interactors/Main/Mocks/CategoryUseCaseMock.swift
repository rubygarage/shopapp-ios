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
    private let error = ShopAppError.content(isNetworkError: false)
    
    var isProductCountLessThenConstant = true
    var isNeedToReturnError = false
    
    override func getCategory(id: String, paginationValue: Any?, sortType: SortType, _ callback: @escaping ApiCallback<Category>) {
        guard !isNeedToReturnError else {
            execute(callback: callback)
            
            return
        }
        
        let category = isProductCountLessThenConstant ? TestHelper.categoryWithFiveProducts : TestHelper.categoryWithTenProducts
        execute(with: category, callback: callback)
    }
    
    private func execute(with category: Category? = nil, callback: @escaping ApiCallback<Category>) {
        isNeedToReturnError ? callback(nil, error) : callback(category, nil)
    }
}
