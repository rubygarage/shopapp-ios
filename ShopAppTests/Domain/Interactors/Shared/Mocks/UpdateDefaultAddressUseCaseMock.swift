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
    
    override func updateDefaultAddress(id: String, callback: @escaping ApiCallback<Void>) {
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
}
