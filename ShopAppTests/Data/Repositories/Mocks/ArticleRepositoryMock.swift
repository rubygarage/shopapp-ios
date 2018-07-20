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
    var isNeedToReturnError = false
    var isGetArticleListStarted = false
    var isGetArticleStarted = false
    var perPage: Int?
    var paginationValue: String?
    var sortBy: SortType?
    var id: String?
    
    func getArticles(perPage: Int, paginationValue: Any?, sortBy: SortType?, callback: @escaping ApiCallback<[Article]>) {
        isGetArticleListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy

        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getArticle(id: String, callback: @escaping ApiCallback<(article: Article, baseUrl: URL)>) {
        isGetArticleStarted = true
        
        self.id = id
        
        if isNeedToReturnError {
            callback(nil, ShopAppError.content(isNetworkError: false))
        } else {
            let baseUrl = URL(string: "https://www.google.com")!
            let result = (article: TestHelper.fullArticle, baseUrl: baseUrl)
            
            callback(result, nil)
        }
    }
}
