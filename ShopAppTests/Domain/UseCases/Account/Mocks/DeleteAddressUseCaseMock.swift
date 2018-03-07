//
//  DeleteAddressUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class DeleteAddressUseCaseMock: DeleteAddressUseCase {
    var isNeedToReturnError = false
    
    override func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
}
