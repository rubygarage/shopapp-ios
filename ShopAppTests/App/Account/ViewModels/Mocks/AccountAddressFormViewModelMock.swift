//
//  AccountAddressFormViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

import ShopApp_Gateway

@testable import ShopApp

class AccountAddressFormViewModelMock: AccountAddressFormViewModel {
    var isAddCustomerStarted = false
    var isUpdateCustomerStarted = false
    
    override func addCustomerAddress(with address: Address) {
        filledAddress.onNext(address)
        isAddCustomerStarted = true
    }
    
    override func updateCustomerAddress(with address: Address) {
        filledAddress.onNext(address)
        isUpdateCustomerStarted = true
    }
}
