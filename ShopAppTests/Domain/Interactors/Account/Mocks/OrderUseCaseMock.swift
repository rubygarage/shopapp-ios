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
    override func getOrder(id: String, _ callback: @escaping ApiCallback<Order>) {
        callback(TestHelper.orderWithProducts, nil)
    }
}
