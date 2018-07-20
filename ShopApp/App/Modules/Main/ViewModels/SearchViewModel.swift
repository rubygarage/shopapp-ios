//
//  SearchViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SearchViewModel: GridCollectionViewModel {
    private let productsUseCase: ProductsUseCase
    
    private var workItem: DispatchWorkItem?
    
    var searchPhrase = Variable<String>("")

    init(productsUseCase: ProductsUseCase) {
        self.productsUseCase = productsUseCase
    }
    
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
            clearResult()
            
            return
        }
        
        workItem?.cancel()
        
        workItem = DispatchWorkItem { [weak self] in
        state.onNext(ViewState.make.loading(showHud: false))
        productsUseCase.getProducts(paginationValue: paginationValue, searchPhrase: searchPhrase.value) { [weak self] (products, error) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.state.onNext(ViewState.make.loading(showHud: false))
            
            strongSelf.productListUseCase.getProducts(with: strongSelf.paginationValue, searchPhrase: strongSelf.searchPhrase.value) { [weak self] (products, error) in
                guard let strongSelf = self else {
                    return
                }
                
                if let error = error {
                    strongSelf.state.onNext(.error(error: error))
                } else if let products = products {
                    strongSelf.updateProducts(products: products)
                    products.isEmpty && !strongSelf.searchPhrase.value.isEmpty ? strongSelf.state.onNext(.empty) : strongSelf.state.onNext(.content)
                }
                
                strongSelf.canLoadMore = products?.count ?? 0 == kItemsPerPage
            }
        }
        
        workItem?.perform()
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        reloadData()
    }
}
