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
    var isNeedToReturnError = false
    var isGetOrderListStarted = false
    var isGetOrderStarted = false
    var perPage: Int?
    var paginationValue: String?
    var id: String?
    
    func getOrders(perPage: Int, paginationValue: Any?, callback: @escaping ApiCallback<[Order]>) {
        isGetOrderListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback([], nil)
    }
    
    func getOrder(id: String, callback: @escaping ApiCallback<Order>) {
        isGetOrderStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.orderWithProducts, nil)
    }
}
