//
//  UpdateAddressUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class UpdateAddressUseCaseMock: UpdateAddressUseCase {
    var isNeedToReturnError = false
    
    override func updateCustomerAddress(address: Address, callback: @escaping RepoCallback<Void>) {
        callback((), isNeedToReturnError ?  RepoError() : nil)
    }
}
