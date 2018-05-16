//
//  CheckoutCreditCardEditTableCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class CheckoutCreditCardEditTableCellDelegateMock: CheckoutCreditCardEditTableCellDelegate {
    var cell: CheckoutCreditCardEditTableViewCell?
    
    // MARK: - CheckoutCreditCardEditTableCellDelegate
    
    func tableViewCellDidTapEditCard(_ cell: CheckoutCreditCardEditTableViewCell) {
        self.cell = cell
    }
}
