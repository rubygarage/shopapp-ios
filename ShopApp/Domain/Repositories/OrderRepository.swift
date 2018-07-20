//
//  OrderRepositoryInterface.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

protocol OrderRepository {
    func getOrders(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[Order]>)
    
    func getOrder(id: String, callback: @escaping ApiCallback<Order>)
}
