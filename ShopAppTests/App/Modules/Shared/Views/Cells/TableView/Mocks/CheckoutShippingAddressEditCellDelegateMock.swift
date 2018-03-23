//
//  CheckoutShippingAddressEditCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckoutShippingAddressEditCellDelegateMock: CheckoutShippingAddressEditCellDelegate {
    var cell: CheckoutShippingAddressEditTableCell?
    
    // MARK: - CheckoutShippingAddressEditCellDelegate
    
    func tableViewCellDidTapEditShippingAddress(_ cell: CheckoutShippingAddressEditTableCell) {
        self.cell = cell
    }
}
