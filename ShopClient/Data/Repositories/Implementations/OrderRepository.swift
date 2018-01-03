//
//  OrderRepository.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

extension Repository {
    func getOrderList(perPage: Int = kItemsPerPage, paginationValue: Any? = nil, callback: @escaping RepoCallback<[Order]>) {
        APICore?.getOrderList(perPage: perPage, paginationValue: paginationValue, callback: callback)
    }
    
    func getOrder(id: String, callback: @escaping RepoCallback<Order>) {
        APICore?.getOrder(id: id, callback: callback)
    }
}
