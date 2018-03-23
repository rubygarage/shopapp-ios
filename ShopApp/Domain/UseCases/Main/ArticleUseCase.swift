//
//  ArticleUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation
import ShopApp_Gateway

class ArticleUseCase {
    private let repository: ArticleRepository

    init(repository: ArticleRepository) {
        self.repository = repository
    }

    func getArticle(with id: String, _ callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        repository.getArticle(id: id, callback: callback)
    }
}
