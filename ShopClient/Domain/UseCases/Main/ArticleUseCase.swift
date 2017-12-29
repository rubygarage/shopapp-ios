//
//  ArticleUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct ArticleUseCase {
    public func getArticle(with id: String, _ callback: @escaping RepoCallback<Article>) {
        Repository.shared.getArticle(id: id, callback: callback)
    }
}
