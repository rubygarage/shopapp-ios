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
    var categories = Variable<[Category]>([])
    
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
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let categories = catogories {
                strongSelf.categories.value = categories
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    func clearResult() {
        updateProducts(products: [])
    }
    
    func categoriesCount() -> Int {
        return categories.value.count
    }
    
    func category(at index: Int) -> Category {
        return categories.value[index]
    }
    
    private func loadRemoteData() {
        guard !searchPhrase.value.isEmpty else {
            updateProducts(products: [])
            return
        }
        
        state.onNext(.loading(showHud: false))
        productListUseCase.getProductList(with: paginationValue, searchPhrase: searchPhrase.value) { [weak self] (products, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let productsArray = products {
                strongSelf.updateProducts(products: productsArray)
                strongSelf.state.onNext(.content)
            }
            strongSelf.canLoadMore = products?.count ?? 0 == kItemsPerPage
        }
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        reloadData()
    }
}
