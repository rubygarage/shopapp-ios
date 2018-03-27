//
//  OrderRepositoryInterface.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol OrderRepository {
    func getOrderList(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>)
    func getOrder(id: String, callback: @escaping RepoCallback<Order>)
}
