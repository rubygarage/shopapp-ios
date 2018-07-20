//
//  OrderUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class OrderUseCase {
    private let repository: OrderRepository

    init(repository: OrderRepository) {
        self.repository = repository
    }

    func getOrder(id: String, _ callback: @escaping ApiCallback<Order>) {
        repository.getOrder(id: id, callback: callback)
    }
}
