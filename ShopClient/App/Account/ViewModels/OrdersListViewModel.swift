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
    
    var items = Variable<[Order]>([Order]())
    
    // MARK: - Private
    
    private func loadRemoteData() {
        let showHud = items.value.isEmpty
        state.onNext(.loading(showHud: showHud))
        orderListUseCase.getOrderList(with: paginationValue) { [weak self] (order, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let order = order {
                self?.updateOrders(with: order)
                self?.state.onNext(.content)
            }
            self?.canLoadMore = order?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateOrders(with orders: [Order]) {
        if paginationValue == nil {
            items.value.removeAll()
        }
        items.value += orders
    }
    
    // MARK: - Internal
    
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
}
