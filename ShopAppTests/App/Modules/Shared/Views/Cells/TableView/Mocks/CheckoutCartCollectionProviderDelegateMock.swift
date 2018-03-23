//
//  CheckoutCartCollectionProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckoutCartCollectionProviderDelegateMock: CheckoutCartCollectionProviderDelegate {
    var provider: CheckoutCartCollectionProvider?
    var productVariantId: String?
    
    // MARK: - CheckoutCartCollectionProviderDelegate
    
    func provider(_ provider: CheckoutCartCollectionProvider, didSelectItemWith productVariantId: String) {
        self.provider = provider
        self.productVariantId = productVariantId
    }
}
