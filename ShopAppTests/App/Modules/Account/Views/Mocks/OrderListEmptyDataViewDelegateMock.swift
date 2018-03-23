//
//  OrderListEmptyDataViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class OrderListEmptyDataViewDelegateMock: OrderListEmptyDataViewDelegate {
    var view: OrderListEmptyDataView?
    
    // MARK: - OrderListEmptyDataViewDelegate
    
    func viewDidTapStartShopping(_ view: OrderListEmptyDataView) {
        self.view = view
    }
}
