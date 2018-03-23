//
//  AddAddressUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class AddAddressUseCaseMock: AddAddressUseCase {
    var isNeedToReturnError = false
    
    override func addAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback(address.id, nil)
    }
}
