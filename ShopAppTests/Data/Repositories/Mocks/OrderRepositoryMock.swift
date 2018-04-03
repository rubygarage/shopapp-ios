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
    
    func getOrderList(perPage: Int, paginationValue: Any?, callback: @escaping RepoCallback<[Order]>) {
        isGetOrderListStarted = true
        
        self.perPage = perPage
        self.paginationValue = paginationValue as? String
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
    
    func getOrder(id: String, callback: @escaping RepoCallback<Order>) {
        isGetOrderStarted = true
        
        self.id = id
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Order(), nil)
    }
}
