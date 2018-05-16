//
//  CheckoutSelectedTypeTableCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class CheckoutSelectedTypeTableCellDelegateMock: CheckoutSelectedTypeTableCellDelegate {
    var cell: CheckoutSelectedTypeTableViewCell?
    
    // MARK: - CheckoutSelectedTypeTableCellDelegate
    
    func tableViewCellDidTapEditPaymentType(_ cell: CheckoutSelectedTypeTableViewCell) {
        self.cell = cell
    }
}
