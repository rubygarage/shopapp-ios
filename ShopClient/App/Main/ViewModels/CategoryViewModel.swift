//
//  CategoryViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CategoryViewModel: GridCollectionViewModel {
    private let categoryUseCase = CategoryUseCase()
    
    var categoryId: String!
    var selectedSortingValue = SortingValue.name
    
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
    }
    
    private func loadRemoteData() {
        let showHud = products.value.isEmpty
        state.onNext(.loading(showHud: showHud))
        let reverse = selectedSortingValue == .createdAt || selectedSortingValue == .priceHighToLow
        categoryUseCase.getCategory(with: categoryId, paginationValue: paginationValue, sortingValue: selectedSortingValue, reverse: reverse) { [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let category = result {
                strongSelf.updateData(category: category)
                strongSelf.state.onNext(.content)
            }
            strongSelf.canLoadMore = result?.products?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateData(category: Category) {
        guard let items = category.products else {
            return
        }
        updateProducts(products: items)
        canLoadMore = products.value.count == kItemsPerPage
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        reloadData()
    }
}
