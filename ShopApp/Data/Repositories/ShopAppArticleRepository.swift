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
    
    func getArticles(perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<[Article]>) {
        api.getArticles(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, callback: callback)
    }
    
    func getArticle(id: String, callback: @escaping ApiCallback<(article: Article, baseUrl: URL)>) {
        api.getArticle(id: id, callback: callback)
    }
}
