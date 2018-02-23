//
//  OrderDetailsTableProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class OrderDetailsTableProviderDelegateMock: NSObject, OrderDetailsTableProviderDelegate {
    var selectedProductVariant: ProductVariant?
    
    // MARK: - OrdersDetailsTableProviderDelegate
    
    func provider(_ provider: OrderDetailsTableProvider, didSelect productVariant: ProductVariant) {
        selectedProductVariant = productVariant
    }
}
