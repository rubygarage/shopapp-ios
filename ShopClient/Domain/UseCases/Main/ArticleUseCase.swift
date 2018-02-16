//
//  ArticleUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

class ArticleUseCase {
    private lazy var repository = AppDelegate.getRepository()

    func getArticle(with id: String, _ callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        repository.getArticle(id: id, callback: callback)
    }
}
