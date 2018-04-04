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
    var sortBy: SortingValue?
    var reverse: Bool?
    var id: String?
    
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping RepoCallback<[Article]>) {
        isGetArticleListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        self.sortBy = sortBy
        self.reverse = reverse
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getArticle(id: String, callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        isGetArticleStarted = true
        
        self.id = id
        
        if isNeedToReturnError {
            callback(nil, RepoError())
        } else {
            let article = Article()
            let baseUrl = URL(string: "https://www.google.com")!
            let result = (article: article, baseUrl: baseUrl)
            
            callback(result, nil)
        }
    }
}
