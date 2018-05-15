//
//  CheckoutShippingOptionsEnabledTableCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CheckoutShippingOptionsEnabledTableCellDelegateMock: CheckoutShippingOptionsEnabledTableCellDelegate {
    var cell: CheckoutShippingOptionsEnabledTableViewCell?
    var shippingRate: ShippingRate?
    
    // MARK: - CheckoutShippingOptionsEnabledTableCellDelegate
    
    func tableViewCell(_ cell: CheckoutShippingOptionsEnabledTableViewCell, didSelect shippingRate: ShippingRate) {
        self.cell = cell
        self.shippingRate = shippingRate
    }
}
