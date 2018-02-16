//
//  CategoryListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

class CategoryListUseCase {
    private lazy var repository = AppDelegate.getRepository()

    func getCategoryList(_ callback: @escaping RepoCallback<[Category]>) {
        repository.getCategoryList(perPage: kItemsPerPage, paginationValue: nil, sortBy: nil, reverse: false, callback: callback)
    }
}
