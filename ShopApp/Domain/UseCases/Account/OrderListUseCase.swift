//
//  OrderListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class OrderListUseCase {
    private let repository: OrderRepository

    init(repository: OrderRepository) {
        self.repository = repository
    }

    func getOrderList(with paginationValue: Any?, _ callback: @escaping RepoCallback<[Order]>) {
        repository.getOrderList(perPage: kItemsPerPage, paginationValue: paginationValue, callback: callback)
    }
}
