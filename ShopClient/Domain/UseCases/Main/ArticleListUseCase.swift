//
//  ArticleUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct ArticleListUseCase {
    func getReverseArticleList(_ callback: @escaping RepoCallback<[Article]>) {
        Repository.shared.getArticleList(reverse: true, callback: callback)
    }

    func getArticleList(with paginationValue: Any?, _ callback: @escaping RepoCallback<[Article]>) {
        Repository.shared.getArticleList(paginationValue: paginationValue, sortBy: SortingValue.createdAt, reverse: true, callback: callback)
    }
}
