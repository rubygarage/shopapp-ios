//
//  CheckoutAddressListViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CheckoutAddressListViewModelMock: CheckoutAddressListViewModel {
    func updateBillingAddress(address: Address) {
        didSelectBillingAddress.onNext(address)
    }
}
