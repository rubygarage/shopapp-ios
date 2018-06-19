//
//  CategoryViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class CategoryViewModel: GridCollectionViewModel {
    private let categoryUseCase: CategoryUseCase
    
    var categoryId: String!
    var selectedSortType = SortType.name

    init(categoryUseCase: CategoryUseCase) {
        self.categoryUseCase = categoryUseCase
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
    }
    
    private func loadRemoteData() {
        let showHud = products.value.isEmpty
        state.onNext(ViewState.make.loading(showHud: showHud))

        categoryUseCase.getCategory(id: categoryId, paginationValue: paginationValue, sortType: selectedSortType) { [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let category = result {
                strongSelf.updateData(category: category)
                strongSelf.products.value.isEmpty ? strongSelf.state.onNext(.empty) : strongSelf.state.onNext(.content)
            }
            strongSelf.canLoadMore = result?.products?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateData(category: ShopApp_Gateway.Category) {
        guard let items = category.products else {
            return
        }
        updateProducts(products: items)
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        reloadData()
    }
}
