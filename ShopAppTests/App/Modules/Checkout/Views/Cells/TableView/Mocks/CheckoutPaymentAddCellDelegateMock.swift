//
//  CheckoutPaymentAddCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class CheckoutPaymentAddCellDelegateMock: CheckoutPaymentAddCellDelegate {
    var cell: CheckoutPaymentAddTableViewCell?
    var paymentType: PaymentAddCellType?
    
    // MARK: - CheckoutPaymentAddCellDelegate
    
    func tableViewCell(_ cell: CheckoutPaymentAddTableViewCell, didTapAdd paymentType: PaymentAddCellType) {
        self.cell = cell
        self.paymentType = paymentType
    }
}
