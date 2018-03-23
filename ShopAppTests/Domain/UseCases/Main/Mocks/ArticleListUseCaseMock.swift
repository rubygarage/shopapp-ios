//
//  ArticleListUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ArticleListUseCaseMock: ArticleListUseCase {
    private let error = ContentError()
    
    var isArticleCountLessThenConstant = true
    var isNeedToReturnError = false
    
    override func getReverseArticleList(_ callback: @escaping RepoCallback<[Article]>) {
        execute(with: callback)
    }
    
    override func getArticleList(with paginationValue: Any?, _ callback: @escaping RepoCallback<[Article]>) {
        execute(with: callback)
    }
    
    private func execute(with callback: @escaping RepoCallback<[Article]>) {
        if isNeedToReturnError {
            callback(nil, error)
        } else {
            let articlesCount = isArticleCountLessThenConstant ? 5 : 10
            var articles: [Article] = []
            
            for _ in 1...articlesCount {
                let article = Article()
                article.paginationValue = "pagination value"
                articles.append(article)
            }
            
            callback(articles, nil)
        }
    }
}
