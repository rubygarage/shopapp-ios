//
//  ArticlesUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ArticlesUseCase {
    private let repository: ArticleRepository

    init(repository: ArticleRepository) {
        self.repository = repository
    }

    func getArticles(paginationValue: Any?, _ callback: @escaping RepoCallback<[Article]>) {
        repository.getArticles(perPage: kItemsPerPage, paginationValue: paginationValue, sortBy: .createdAt, callback: callback)
    }
}
