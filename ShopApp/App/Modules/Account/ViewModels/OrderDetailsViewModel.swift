//
//  OrderDetailsViewModel.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class OrderDetailsViewModel: BaseViewModel {
    private let orderUseCase: OrderUseCase
    
    var orderId: String!
    var data = Variable<Order?>(nil)

    init(orderUseCase: OrderUseCase) {
        self.orderUseCase = orderUseCase
    }
    
    func loadOrder() {
        state.onNext(ViewState.make.loading())
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
