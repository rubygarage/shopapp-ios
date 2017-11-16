//
//  ArticleDetailsViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class ArticleDetailsViewModel: BaseViewModel {
    var articleId: String!
    
    var data: Single<Article> {
        state.onNext(.loading(showHud: true))
        return Single.create(subscribe: { (single) in
            Repository.shared.getArticle(id: self.articleId, callback: { [weak self] (article, error) in
                if let error = error {
                    self?.state.onNext(.error(error))
                }
                if let article = article {
                    single(.success(article))
                    self?.state.onNext(.content)
                }
            })
            return Disposables.create()
        })
    }
}
