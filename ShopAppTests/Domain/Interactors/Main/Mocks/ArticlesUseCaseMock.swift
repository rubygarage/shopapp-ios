//
//  ArticlesUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ArticlesUseCaseMock: ArticlesUseCase {
    private let error = ShopAppError.content(isNetworkError: false)
    
    var isArticleCountLessThenConstant = true
    var isNeedToReturnError = false

    override func getArticles(paginationValue: Any?, _ callback: @escaping ApiCallback<[Article]>) {
        execute(with: callback)
    }
    
    private func execute(with callback: @escaping ApiCallback<[Article]>) {
        if isNeedToReturnError {
            callback(nil, error)
        } else {
            let articlesCount = isArticleCountLessThenConstant ? 5 : 10
            var articles: [Article] = []
            
            for _ in 1...articlesCount {
                articles.append(TestHelper.fullArticle)
            }
            
            callback(articles, nil)
        }
    }
}
