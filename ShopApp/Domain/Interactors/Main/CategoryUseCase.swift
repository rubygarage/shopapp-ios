//
//  CategoryUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class CategoryUseCase {
    private let repository: CategoryRepository

    init(repository: CategoryRepository) {
        self.repository = repository
    }

    func getCategory(with id: String, paginationValue: Any?, sortType: SortType, _ callback: @escaping RepoCallback<ShopApp_Gateway.Category>) {
        repository.getCategory(id: id, perPage: kItemsPerPage, paginationValue: paginationValue, sortBy: sortType, callback: callback)
    }
}
