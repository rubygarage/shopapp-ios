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
    private let response = (article: Article(), baseUrl: URL(string: "www.google.com")!)
    private let error = ContentError()
    
    var isNeedToReturnError = false
    
    override func getArticle(with id: String, _ callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping RepoCallback<(article: Article, baseUrl: URL)>) {
        isNeedToReturnError ? callback(nil, error) : callback(response, nil)
    }
}
