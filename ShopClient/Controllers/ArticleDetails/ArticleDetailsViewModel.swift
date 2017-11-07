//
//  ArticleDetailsViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class ArticleDetailsViewModel: BaseViewModel {
    var articleId = String()
    
    var data: Single<Article> {
        state.onNext((state: .loading, error: nil))
        
        return Single.create(subscribe: { (single) in
            Repository.shared.getArticle(id: self.articleId , callback: { [weak self] (article, error) in
                if let error = error {
                    self?.state.onNext((state: .error, error: error))
                }
                if let article = article {
                    single(.success(article))
                    self?.state.onNext((state: .content, error: nil))
                }
            })
            return Disposables.create()
        })
    }
}
