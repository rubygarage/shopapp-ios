//
//  OrdersListViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class OrdersListViewModel: BasePaginationViewModel {
    private let orderListUseCase = OrderListUseCase()
    
    var items = Variable<[Order]>([])
    
    func reloadData() {
        paginationValue = nil
        loadRemoteData()
    }
    
    func loadNextPage() {
        paginationValue = items.value.last?.paginationValue
        loadRemoteData()
    }
    
    func productVariant(with productVariantId: String, at index: Int) -> ProductVariant? {
        var variant: ProductVariant?
        let order = items.value[index]
        
        if let items = order.items {
            items.forEach {
                if let productVariant = $0.productVariant, productVariant.id == productVariantId {
                    variant = productVariant
                }
            }
        }
        
        return variant
    }
    
    private func loadRemoteData() {
        let showHud = items.value.isEmpty
        state.onNext(.loading(showHud: showHud))
        orderListUseCase.getOrderList(with: paginationValue) { [weak self] (order, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let order = order {
                strongSelf.updateOrders(with: order)
                strongSelf.updateSuccessState(with: order.count)
            }
            strongSelf.canLoadMore = order?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateOrders(with orders: [Order]) {
        if paginationValue == nil {
            items.value.removeAll()
        }
        items.value += orders
    }
    
    private func updateSuccessState(with itemsCount: Int) {
        if itemsCount > 0 {
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
