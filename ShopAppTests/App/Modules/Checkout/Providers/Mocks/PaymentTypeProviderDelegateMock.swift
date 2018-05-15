//
//  PaymentTypeProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class PaymentTypeProviderDelegateMock: PaymentTypeProviderDelegate {
    var provider: PaymentTypeProvider?
    var type: PaymentType?
    
    // MARK: - PaymentTypeProviderDelegate
    
    func provider(_ provider: PaymentTypeProvider, didSelect type: PaymentType) {
        self.provider = provider
        self.type = type
    }
}
