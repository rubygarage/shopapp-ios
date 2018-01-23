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
    var data = PublishSubject<Article>()

    // MARK: - BaseViewModel

    override func tryAgain() {
        loadData()
    }

    func loadData() {
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
