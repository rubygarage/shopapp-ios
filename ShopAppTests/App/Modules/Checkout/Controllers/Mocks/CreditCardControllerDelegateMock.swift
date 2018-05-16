//
//  CreditCardControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CreditCardControllerDelegateMock: CreditCardControllerDelegate {
    var controller: CreditCardViewController?
    var card: CreditCard?
    
    // MARK: - CreditCardControllerDelegate
    
    func viewController(_ controller: CreditCardViewController, didFilled card: CreditCard) {
        self.controller = controller
        self.card = card
    }
}
