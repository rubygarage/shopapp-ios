//
//  CategoryRepositoryMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CategoryRepositoryMock: CategoryRepository {
    var isNeedToReturnError = false
    var isGetCategoryListStarted = false
    var isGetCategoryDetailsStarted = false
    var perPage: Int?
    var paginationValue: String?
    var sortBy: SortType?
    var id: String?
    
    func getCategories(perPage: Int, paginationValue: Any?, parentCategoryId: String?, callback: @escaping RepoCallback<[Category]>) {
        isGetCategoryListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String

        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getCategory(id: String, perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping RepoCallback<Category>) {
        isGetCategoryDetailsStarted = true
        
        self.id = id
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Category(), nil)
    }
}
