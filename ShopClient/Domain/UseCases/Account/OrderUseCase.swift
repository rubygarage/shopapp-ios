//
//  OrderUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct OrderUseCase {
    public func getOrder(with id: String, _ callback: @escaping RepoCallback<Order>) {
        Repository.shared.getOrder(id: id, callback: callback)
    }
}
