//
//  CheckoutShippingAddressAddCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class CheckoutShippingAddressAddCellDelegateMock: CheckoutShippingAddressAddCellDelegate {
    var cell: CheckoutShippingAddressAddTableViewCell?
    
    // MARK: - CheckoutShippingAddressAddCellDelegate
    
    func tableViewCellDidTapAddNewAddress(_ cell: CheckoutShippingAddressAddTableViewCell) {
        self.cell = cell
    }
}
