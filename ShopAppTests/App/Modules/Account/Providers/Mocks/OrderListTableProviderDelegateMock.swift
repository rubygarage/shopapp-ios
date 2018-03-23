//
//  OrderListTableProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class OrderListTableProviderDelegateMock: NSObject, OrderListTableProviderDelegate, CheckoutCartTableViewCellDelegate {
    var selectedOrder: Order?
    var selectedProductVariantId: String?
    var selectedIndex: Int?
    
    // MARK: - OrderListTableProviderDelegate
    
    func provider(_ provider: OrderListTableProvider, didSelect order: Order) {
        selectedOrder = order
    }
    
    // MARK: - CheckoutCartTableViewCellDelegate
    
    func tableViewCell(_ cell: CheckoutCartTableViewCell, didSelect productVariantId: String, at index: Int) {
        selectedProductVariantId = productVariantId
        selectedIndex = index
    }
}
