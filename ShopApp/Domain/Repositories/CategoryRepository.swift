//
//  CategoryRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol CategoryRepository {
    func getCategories(perPage: Int, paginationValue: Any?, parentCategoryId: String?, callback: @escaping RepoCallback<[Category]>)

    func getCategory(id: String, perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping RepoCallback<Category>)
}
