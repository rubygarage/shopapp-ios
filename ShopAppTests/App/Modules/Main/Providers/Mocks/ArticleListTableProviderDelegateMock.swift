//
//  ArticlesListTableProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class ArticleListTableProviderDelegateMock: NSObject, ArticleListTableProviderDelegate {
    var provider: ArticleListTableProvider?
    var article: Article?
    
    // MARK: - ArticlesListTableProviderDelegate
    
    func provider(_ provider: ArticleListTableProvider, didSelect article: Article) {
        self.provider = provider
        self.article = article
    }
}
