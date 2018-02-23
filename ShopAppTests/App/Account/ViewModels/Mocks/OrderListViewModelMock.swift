//
//  OrderListViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class OrderListViewModelMock: OrderListViewModel {
    var isNeedToReturnData = false
    
    override func reloadData() {
        if isNeedToReturnData {
            items.value = [Order()]
        }
    }
}
