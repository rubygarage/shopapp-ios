//
//  CheckoutBillingAddressEditCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class CheckoutBillingAddressEditCellDelegateMock: CheckoutBillingAddressEditCellDelegate {
    var cell: CheckoutBillingAddressEditTableViewCell?
    
    // MARK: - CheckoutBillingAddressEditCellDelegate
    
    func tableViewCellDidTapEditBillingAddress(_ cell: CheckoutBillingAddressEditTableViewCell) {
        self.cell = cell
    }
}
