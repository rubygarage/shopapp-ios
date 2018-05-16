//
//  CheckoutFailureViewControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class CheckoutFailureViewControllerDelegateMock: CheckoutFailureViewControllerDelegate {
    var controller: CheckoutFailureViewController?
    
    // MARK: - CheckoutFailureViewControllerDelegate
    
    func viewControllerDidTapTryAgain(_ controller: CheckoutFailureViewController) {
        self.controller = controller
    }
}
