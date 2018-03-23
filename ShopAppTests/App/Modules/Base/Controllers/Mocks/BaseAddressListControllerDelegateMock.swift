//
//  BaseAddressListControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class BaseAddressListControllerDelegateMock: NSObject, BaseAddressListControllerDelegate {
    var selectedAddress: Address?
    
    func viewController(didSelectBillingAddress address: Address) {
        selectedAddress = address
    }
}
