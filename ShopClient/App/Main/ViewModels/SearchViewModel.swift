//
//  SearchViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SearchViewModel: GridCollectionViewModel {
    private let productListUseCase = ProductListUseCase()
    
    var searchPhrase = Variable<String>("")
    
    func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    func loadNextPage() {
        paginationValue = products.value.last?.paginationValue
        loadRemoteData()
    }
    
    func clearResult() {
        updateProducts(products: [])
        state.onNext(.content)
    }
    
    private func loadRemoteData() {
        guard !searchPhrase.value.isEmpty else {
            updateProducts(products: [])
            state.onNext(.content)
            return
        }
        state.onNext(.loading(showHud: false))
        productListUseCase.getProductList(with: paginationValue, searchPhrase: searchPhrase.value) { [weak self] (products, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let products = products {
                strongSelf.updateProducts(products: products)
                strongSelf.updateSuccessState(with: products.count)
            }
            strongSelf.canLoadMore = products?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateSuccessState(with itemsCount: Int) {
        if itemsCount > 0 || searchPhrase.value.isEmpty {
            state.onNext(.content)
        } else {
            state.onNext(.empty)
        }
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        reloadData()
    }
}
