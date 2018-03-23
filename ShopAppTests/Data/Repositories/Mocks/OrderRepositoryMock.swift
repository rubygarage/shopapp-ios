//
//  OrderRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class OrderRepositoryMock: OrderRepository {
    func getOrderList(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>) {}
    func getOrder(id: String, callback: @escaping RepoCallback<Order>) {}
}
