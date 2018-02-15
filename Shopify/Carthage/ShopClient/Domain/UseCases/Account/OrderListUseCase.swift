//
//  OrderListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

struct OrderListUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func getOrderList(with paginationValue: Any?, _ callback: @escaping RepoCallback<[Order]>) {
        repository.getOrderList(perPage: kItemsPerPage, paginationValue: paginationValue, callback: callback)
    }
}
