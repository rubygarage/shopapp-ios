//
//  ArticleUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import ShopApp_Gateway

@testable import ShopApp

class ArticleUseCaseMock: ArticleUseCase {
    private let response = (article: TestHelper.fullArticle, baseUrl: URL(string: "www.google.com")!)
    private let error = ShopAppError.content(isNetworkError: false)
    
    var isNeedToReturnError = false
    
    override func getArticle(id: String, _ callback: @escaping ApiCallback<(article: Article, baseUrl: URL)>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping ApiCallback<(article: Article, baseUrl: URL)>) {
        isNeedToReturnError ? callback(nil, error) : callback(response, nil)
    }
}
