//
//  OrderUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

struct OrderUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func getOrder(with id: String, _ callback: @escaping RepoCallback<Order>) {
        repository.getOrder(id: id, callback: callback)
    }
}
