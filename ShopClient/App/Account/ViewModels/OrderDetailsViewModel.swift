//
//  OrderDetailsViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class OrderDetailsViewModel: BaseViewModel {
    private let orderUseCase = OrderUseCase()
    
    var orderId: String!
    var data = Variable<Order?>(nil)
    
    // MARK: - Internal
    
    func productVariant(at index: Int) -> ProductVariant? {
        var variant: ProductVariant?

        if let order = data.value, let item = order.items?[index], let productVariant = item.productVariant {
            variant = productVariant
        }
        
        return variant
    }
    
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

    // MARK: - BaseViewModel

    override func tryAgain() {
        loadOrder()
    }
}
