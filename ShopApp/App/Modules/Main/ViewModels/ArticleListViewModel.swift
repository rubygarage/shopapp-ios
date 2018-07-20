//
//  ArticleListViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class ArticleListViewModel: BasePaginationViewModel {
    private let articlesUseCase: ArticlesUseCase
    
    var items = Variable<[Article]>([])

    init(articlesUseCase: ArticlesUseCase) {
        self.articlesUseCase = articlesUseCase
    }
    
    func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    func loadNextPage() {
        paginationValue = items.value.last?.paginationValue
        loadRemoteData()
    }
    
    private func loadRemoteData() {
        let showHud = items.value.isEmpty
        state.onNext(ViewState.make.loading(showHud: showHud))
        articlesUseCase.getArticles(paginationValue: paginationValue) { [weak self] (articles, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let articles = articles {
                strongSelf.updateArticles(with: articles)
                strongSelf.state.onNext(.content)
            }
            strongSelf.canLoadMore = articles?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateArticles(with articles: [Article]) {
        if paginationValue == nil {
            items.value.removeAll()
        }
        items.value += articles
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        reloadData()
    }
}
