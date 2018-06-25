//
//  ShopAppOrderRepository.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

public class ShopAppOrderRepository: OrderRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    public func getOrders(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[Order]>) {
        api.getOrders(perPage: perPage, paginationValue: paginationValue, callback: callback)
    }
    
    public func getOrder(id: String, callback: @escaping ApiCallback<Order>) {
        api.getOrder(id: id, callback: callback)
    }
}
