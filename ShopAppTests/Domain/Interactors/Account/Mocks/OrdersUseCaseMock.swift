//
//  OrdersUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class OrdersUseCaseMock: OrdersUseCase {
    var isOrderCountLessThenConstant = true
    var isNeedToReturnOrderWithVariant = false
    var isNeedToReturnError = false
    
    override func getOrders(paginationValue: Any?, _ callback: @escaping ApiCallback<[Order]>) {
        if isNeedToReturnError {
            callback(nil, ShopAppError.content(isNetworkError: false))
        } else {
            let ordersCount = isOrderCountLessThenConstant ? 5 : 10
            var orders: [Order] = []
            for index in 1...ordersCount {
                let order = generatedOrder(with: index)
                orders.append(order)
            }
            callback(orders, nil)
        }
    }
    
    private func generatedOrder(with index: Int) -> Order {
        return isNeedToReturnOrderWithVariant && index == 1 ? TestHelper.orderWithProducts : TestHelper.orderWithoutProducts
    }
}
