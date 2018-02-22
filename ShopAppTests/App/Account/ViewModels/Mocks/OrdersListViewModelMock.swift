//
//  OrdersListViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class OrdersListViewModelMock: OrdersListViewModel {
    override func reloadData() {
        items.value = [Order()]
    }
}
