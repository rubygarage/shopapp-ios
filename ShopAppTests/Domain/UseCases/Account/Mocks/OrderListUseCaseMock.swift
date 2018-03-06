//
//  OrderListUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class OrderListUseCaseMock: OrderListUseCase {
    var isOrderCountLessThenConstant = true
    var isNeedToReturnOrderWithVariant = false
    var isNeedToReturnError = false
    
    override func getOrderList(with paginationValue: Any?, _ callback: @escaping RepoCallback<[Order]>) {
        if isNeedToReturnError {
            callback(nil, RepoError())
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
        let order = Order()
        order.paginationValue = "pagination value"
        
        if isNeedToReturnOrderWithVariant && index == 1 {
            let productVariant = ProductVariant()
            productVariant.id = "product variant id"
            
            let orderItem = OrderItem()
            orderItem.productVariant = productVariant
            
            order.items = [orderItem]
        }
        
        return order
    }
}
