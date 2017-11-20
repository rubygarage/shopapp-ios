//
//  ArticlesListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class ArticlesListViewModel: BasePaginationViewModel {
    var items = Variable<[Article]>([Article]())
    
    public func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    public func loadNextPage() {
        paginationValue = items.value.last?.paginationValue
        loadRemoteData()
    }
    
    private func loadRemoteData() {
        let showHud = items.value.count == 0
        state.onNext(.loading(showHud: showHud))
        Repository.shared.getArticleList(paginationValue: paginationValue, sortBy: SortingValue.createdAt, reverse: true) { [weak self] (articles, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let articles = articles {
                self?.updateArticles(with: articles)
                self?.state.onNext(.content)
            }
            self?.canLoadMore = articles?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateArticles(with articles: [Article]) {
        if paginationValue == nil {
            items.value.removeAll()
        }
        items.value += articles
    }
}
