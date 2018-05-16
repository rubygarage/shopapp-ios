//
//  PaymentTypeViewControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class PaymentTypeViewControllerDelegateMock: PaymentTypeViewControllerDelegate {
    var viewController: PaymentTypeViewController?
    var paymentType: PaymentType?
    
    // MARK: - PaymentTypeViewControllerDelegate
    
    func viewController(_ viewController: PaymentTypeViewController, didSelect paymentType: PaymentType) {
        self.viewController = viewController
        self.paymentType = paymentType
    }
}
