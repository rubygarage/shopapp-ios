//
//  OrderUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class OrderUseCaseMock: OrderUseCase {    
    override func getOrder(with id: String, _ callback: @escaping RepoCallback<Order>) {
        let order = Order()
        order.id = "order id"
        callback(order, nil)
    }
}
