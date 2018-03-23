//
//  AddressFormControllerlDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import ShopApp_Gateway

@testable import ShopApp

class AddressFormControllerlDelegateMock: NSObject, AddressFormControllerlDelegate {
    var filledAddress: Address?
    
    // MARK: - AddressFormControllerlDelegate
    
    func viewController(_ controller: AddressFormViewController, didFill address: Address) {
        filledAddress = address
    }
}
