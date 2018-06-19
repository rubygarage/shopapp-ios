//
//  CartValidationUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 4/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class SetupProviderUseCaseMock: SetupProviderUseCase {
    var isNeedToReturnError = false
    
    override func setupProvider(callback: @escaping RepoCallback<Void>) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback(nil, nil)
    }
}
