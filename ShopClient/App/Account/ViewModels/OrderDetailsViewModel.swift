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
    
    func productVariant(at index: Int) -> ProductVariant? {
        guard let order = data.value, let item = order.items?[index], let productVariant = item.productVariant else {
            return nil
        }
        return productVariant
    }
    
    func loadOrder() {
        state.onNext(.loading(showHud: true))
        orderUseCase.getOrder(with: orderId) { [weak self] (order, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let order = order {
                strongSelf.data.value = order
                strongSelf.state.onNext(.content)
            }
        }
    }

    // MARK: - BaseViewModel

    override func tryAgain() {
        loadOrder()
    }
}
