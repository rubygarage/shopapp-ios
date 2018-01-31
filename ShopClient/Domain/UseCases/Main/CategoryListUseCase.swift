//
//  CategoryListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct CategoryListUseCase {
    func getCategoryList(_ callback: @escaping RepoCallback<[Category]>) {
        Repository.shared.getCategoryList(callback: callback)
    }
}
