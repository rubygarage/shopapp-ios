//
//  ArticleDetailsViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class ArticleDetailsViewModel: BaseViewModel {
    private let articleUseCase = ArticleUseCase()

    var articleId: String!
    var data = PublishSubject<(article: Article, baseUrl: URL)>()

    func loadData() {
        state.onNext(ViewState.make.loading())
        articleUseCase.getArticle(with: articleId) { [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let result = result {
                strongSelf.data.onNext(result)
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        loadData()
    }
}
