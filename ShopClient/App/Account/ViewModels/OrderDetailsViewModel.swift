//
//  OrderDetailsViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class OrderDetailsViewModel: BaseViewModel {
    var data = PublishSubject<Order>()
    
    var orderId: String!
    
    var loadData: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.loadOrder()
        }
    }
    
    private let orderUseCase = OrderUseCase()
    
    func loadOrder() {
        state.onNext(.loading(showHud: true))
        orderUseCase.getOrder(with: orderId) { [weak self] (order, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let order = order {
                self?.data.onNext(order)
                self?.state.onNext(.content)
            }
        }
    }
}
