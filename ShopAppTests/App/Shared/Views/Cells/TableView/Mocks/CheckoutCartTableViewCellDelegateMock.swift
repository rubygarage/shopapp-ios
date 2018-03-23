//
//  CheckoutCartTableViewCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckoutCartTableViewCellDelegateMock: CheckoutCartTableViewCellDelegate {
    var cell: CheckoutCartTableViewCell?
    var productVariantId: String?
    var index: Int?
    
    // MARK: - CheckoutCartTableViewCellDelegate
    
    func tableViewCell(_ cell: CheckoutCartTableViewCell, didSelect productVariantId: String, at index: Int) {
        self.cell = cell
        self.productVariantId = productVariantId
        self.index = index
    }
}
