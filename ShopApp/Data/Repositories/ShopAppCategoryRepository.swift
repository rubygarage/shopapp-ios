//
//  ShopAppCategoryRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ShopAppCategoryRepository: CategoryRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func getCategories(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[Category]>) {
        api.getCategories(perPage: perPage, paginationValue: paginationValue, callback: callback)
    }
    
    func getCategory(id: String, perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<Category>) {
        api.getCategory(id: id, perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, callback: callback)
    }
}
