//
//  OrderListViewModel.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class OrderListViewModel: BasePaginationViewModel {
    private let ordersUseCase: OrdersUseCase
    
    var items = Variable<[Order]>([])

    init(ordersUseCase: OrdersUseCase) {
        self.ordersUseCase = ordersUseCase
    }
    
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
        state.onNext(ViewState.make.loading(showHud: showHud))
        ordersUseCase.getOrders(paginationValue: paginationValue) { [weak self] (orders, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let order = orders {
                strongSelf.updateOrders(with: order)
                order.isEmpty ? strongSelf.state.onNext(.empty) : strongSelf.state.onNext(.content)
            }
            strongSelf.canLoadMore = orders?.count ?? 0 == kItemsPerPage
        }
    }
    
    private func updateOrders(with orders: [Order]) {
        if paginationValue == nil {
            items.value.removeAll()
        }
        items.value += orders
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        reloadData()
    }
}
