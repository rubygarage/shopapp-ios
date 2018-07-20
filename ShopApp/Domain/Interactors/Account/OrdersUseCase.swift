//
//  OrdersUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class OrdersUseCase {
    private let repository: OrderRepository

    init(repository: OrderRepository) {
        self.repository = repository
    }

    func getOrders(paginationValue: Any?, _ callback: @escaping ApiCallback<[Order]>) {
        repository.getOrders(perPage: kItemsPerPage, paginationValue: paginationValue, callback: callback)
    }
}
