//
//  OrderListUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct OrderListUseCase {
    public func getOrderList(with paginationValue: Any?, _ callback: @escaping RepoCallback<[Order]>) {
        Repository.shared.getOrderList(paginationValue: paginationValue, callback: callback)
    }
}
