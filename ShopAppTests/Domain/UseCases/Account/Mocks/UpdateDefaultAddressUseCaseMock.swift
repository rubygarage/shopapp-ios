//
//  UpdateDefaultAddressUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class UpdateDefaultAddressUseCaseMock: UpdateDefaultAddressUseCase {
    var isNeedToReturnError = false
    
    override func updateDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        if isNeedToReturnError {
            callback(nil, RepoError())
        } else {
            let customer = Customer()
            let defaultAddress = Address()
            defaultAddress.id = "Customer default address id"
            customer.defaultAddress = defaultAddress
            
            let address = Address()
            address.id = "Customer address id"
            customer.addresses = [address]
            
            callback(customer, nil)
        }
    }
}
