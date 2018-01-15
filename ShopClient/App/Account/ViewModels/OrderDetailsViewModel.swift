//
//  OrderDetailsViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class OrderDetailsViewModel: BaseViewModel {
    var data = Variable<Order?>(nil)
    
    var orderId: String!
    
    var loadData: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.loadOrder()
        }
    }
    
    public func productVariant(at index: Int) -> ProductVariant? {
        var variant: ProductVariant?

        if let order = data.value, let item = order.items?[index], let productVariant = item.productVariant {
            variant = productVariant
        }
        
        return variant
    }
    
    private let orderUseCase = OrderUseCase()
    
    func loadOrder() {
        state.onNext(.loading(showHud: true))
        orderUseCase.getOrder(with: orderId) { [weak self] (order, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let order = order {
                self?.data.value = order
                self?.state.onNext(.content)
            }
        }
    }
}
