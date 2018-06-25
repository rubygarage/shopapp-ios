//
//  SetupProviderRepositoryMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 6/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class SetupProviderRepositoryMock: SetupProviderRepository {
    var isNeedToReturnError = false
    var isSetupProviderStarted = false
    
    func setupProvider(callback: @escaping ApiCallback<Void>) {
        isSetupProviderStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(nil, nil)
    }
}
