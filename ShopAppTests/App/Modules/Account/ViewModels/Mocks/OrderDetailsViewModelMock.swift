//
//  OrderDetailsViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class OrderDetailsViewModelMock: OrderDetailsViewModel {
    var order: Order!
    var isLoadingOrderStarted = false
    
    override func loadOrder() {
        data.value = order
        isLoadingOrderStarted = true
    }
    
    func makeEmptyData() {
        order = nil
    }
    
    func makeNotEmptyData() {
        order = Order()
        order.id = "order id"
        
        let orderItem = OrderItem()
        orderItem.quantity = 1
        order.items = [orderItem]
    }
}
