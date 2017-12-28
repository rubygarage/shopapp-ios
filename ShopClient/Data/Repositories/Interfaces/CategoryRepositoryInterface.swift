//
//  CategoryRepositoryInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

protocol CategoryRepositoryInterface {
    func getCategoryList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Category]>)
    func getCategoryDetails(id: String, perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<Category>)
}
