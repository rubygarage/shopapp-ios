//
//  ArticleRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

extension ShopifyRepository: ArticleRepository {
    public func getArticleList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, sortBy: SortingValue? = nil, reverse: Bool = false, callback: @escaping RepoCallback<[Article]>) {
        api.getArticleList(perPage: perPage, paginationValue: paginationValue, sortBy: sortBy, reverse: reverse, callback: callback)
    }
    
    public func getArticle(id: String, callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        api.getArticle(id: id, callback: callback)
    }
}
