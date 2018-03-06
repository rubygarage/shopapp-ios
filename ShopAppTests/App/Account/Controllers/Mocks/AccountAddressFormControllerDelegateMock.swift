//
//  AccountAddressFormControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import ShopApp_Gateway

@testable import ShopApp

class AccountAddressFormControllerDelegateMock: NSObject, AccountAddressFormControllerDelegate {
    var updatedAddress: Address!
    var addedAddress: Address!
    
    func viewController(_ controller: AccountAddressFormViewController, didUpdate address: Address) {
        updatedAddress = address
    }
    
    func viewController(_ controller: AccountAddressFormViewController, didAdd address: Address) {
        addedAddress = address
    }
}
