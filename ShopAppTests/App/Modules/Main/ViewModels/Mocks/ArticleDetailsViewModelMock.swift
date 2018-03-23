//
//  ArticleDetailsViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class ArticleDetailsViewModelMock: ArticleDetailsViewModel {
    var isNeedToReturnImageOfArticle = false
    var isLoadDataStarted = false
    
    override func loadData() {
        isLoadDataStarted = true
        
        let author = Author()
        author.fullName = "First Last"
        
        let article = Article()
        article.title = "Title"
        article.author = author
        article.contentHtml = "<b>This text is bold</b>"
        
        if isNeedToReturnImageOfArticle {
            article.image = Image()
        }
        
        let url = URL(string: "www.google.com")!
        let result = (article: article, baseUrl: url)
        
        data.onNext(result)
    }
}
