//
//  ArticleRepositoryMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import ShopApp_Gateway

@testable import ShopApp

class ArticleRepositoryMock: ArticleRepository {
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Article]>) {}
    func getArticle(id: String, callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {}
}
