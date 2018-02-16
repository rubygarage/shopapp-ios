//
//  OrderUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

class OrderUseCase {
    private lazy var repository = AppDelegate.getRepository()

    func getOrder(with id: String, _ callback: @escaping RepoCallback<Order>) {
        repository.getOrder(id: id, callback: callback)
    }
}
