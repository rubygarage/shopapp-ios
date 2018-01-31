//
//  CategoryUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct CategoryUseCase {
    func getCategory(with id: String, paginationValue: Any?, sortingValue: SortingValue, reverse: Bool, _ callback: @escaping RepoCallback<Category>) {
        Repository.shared.getCategoryDetails(id: id, paginationValue: paginationValue, sortBy: sortingValue, reverse: reverse, callback: callback)
    }
}
