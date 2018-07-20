//
//  ArticleRepository.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol ArticleRepository {
    func getArticles(perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<[Article]>)
    
    func getArticle(id: String, callback: @escaping ApiCallback<(article: Article, baseUrl: URL)>)
}
