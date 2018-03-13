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
        execute(callback: callback)
    }
    
    override func getArticleList(with paginationValue: Any?, _ callback: @escaping RepoCallback<[Article]>) {
        guard !isNeedToReturnError else {
            execute(callback: callback)
            
            return
        }
        
        let articlesCount = isArticleCountLessThenConstant ? 5 : 10
        var articles: [Article] = []
        
        for _ in 1...articlesCount {
            let article = Article()
            article.paginationValue = "pagination value"
            articles.append(article)
        }
        
        execute(with: articles, callback: callback)
    }
    
    private func execute(with articles: [Article] = [], callback: @escaping RepoCallback<[Article]>) {
        isNeedToReturnError ? callback(nil, error) : callback(articles, nil)
    }
}
