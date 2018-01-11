//
//  ArticleDetailsViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class ArticleDetailsViewModel: BaseViewModel {
    var data = PublishSubject<Article>()
    
    var articleId: String!
    
    var loadData: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.loadArticle()
        }
    }
    
    private let articleUseCase = ArticleUseCase()
    
    func loadArticle() {
        state.onNext(.loading(showHud: true))
        articleUseCase.getArticle(with: articleId) { [weak self] (article, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let article = article {
                self?.data.onNext(article)
                self?.state.onNext(.content)
            }
        }
    }
}
