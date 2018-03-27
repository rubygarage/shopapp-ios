//
//  ShopAppArticleRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ShopAppArticleRepository: ArticleRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Article]>) {
        api.getArticleList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
    
    func getArticle(id: String, callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        api.getArticle(id: id, callback: callback)
    }
}
