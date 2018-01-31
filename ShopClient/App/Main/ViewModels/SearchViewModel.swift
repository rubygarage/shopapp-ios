//
//  SearchViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SearchViewModel: GridCollectionViewModel {
    private let categoryListUseCase = CategoryListUseCase()
    private let productListUseCase = ProductListUseCase()
    
    var searchPhrase = Variable<String>("")
    var categories = Variable<[Category]>([Category]())

    // MARK: - BaseViewModel

    override func tryAgain() {
        reloadData()
    }
    
    func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    func loadNextPage() {
        paginationValue = products.value.last?.paginationValue
        loadRemoteData()
    }
    
    func loadCategories() {
        state.onNext(.loading(showHud: true))
        categoryListUseCase.getCategoryList { [weak self] (catogories, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let categories = catogories {
                self?.categories.value = categories
                self?.state.onNext(.content)
            }
        }
    }
    
    func clearResult() {
        updateProducts(products: [Product]())
    }
    
    func categoriesCount() -> Int {
        return categories.value.count
    }
    
    func category(at index: Int) -> Category {
        return categories.value[index]
    }
    
    private func loadRemoteData() {
        guard !searchPhrase.value.isEmpty else {
            updateProducts(products: [Product]())
            return
        }
        
        state.onNext(.loading(showHud: false))
        productListUseCase.getProductList(with: paginationValue, searchPhrase: searchPhrase.value) { [weak self] (products, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let productsArray = products {
                self?.updateProducts(products: productsArray)
                self?.state.onNext(.content)
            }
            self?.canLoadMore = products?.count ?? 0 == kItemsPerPage
        }
    }
}
