//
//  ArticleUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

struct ArticleUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func getArticle(with id: String, _ callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        repository.getArticle(id: id, callback: callback)
    }
}
