//
//  ArticleUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ArticleListUseCase {
    private let repository: ArticleRepository

    init(repository: ArticleRepository) {
        self.repository = repository
    }

    func getReverseArticleList(_ callback: @escaping RepoCallback<[Article]>) {
        repository.getArticleList(perPage: kItemsPerPage, paginationValue: nil, sortBy: nil, reverse: true, callback: callback)
    }

    func getArticleList(with paginationValue: Any?, _ callback: @escaping RepoCallback<[Article]>) {
        repository.getArticleList(perPage: kItemsPerPage, paginationValue: paginationValue, sortBy: SortingValue.createdAt, reverse: true, callback: callback)
    }
}
