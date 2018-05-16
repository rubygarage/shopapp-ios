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
    var sortBy: SortingValue?
    var reverse: Bool?
    var id: String?
    
    func getCategoryList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Category]>) {
        isGetCategoryListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.reverse = reverse
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getCategoryDetails(id: String, perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<Category>) {
        isGetCategoryDetailsStarted = true
        
        self.id = id
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.reverse = reverse
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Category(), nil)
    }
}
