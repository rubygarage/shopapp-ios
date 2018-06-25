//
//  CategoryListUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class CategoriesUseCase {
    private let repository: CategoryRepository

    init(repository: CategoryRepository) {
        self.repository = repository
    }

    func getCategoryList(paginationValue: Any?, _ callback: @escaping ApiCallback<[ShopApp_Gateway.Category]>) {
        repository.getCategories(perPage: kItemsPerPage, paginationValue: paginationValue, callback: callback)
    }
}
