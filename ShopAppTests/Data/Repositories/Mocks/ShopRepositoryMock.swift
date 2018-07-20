//
//  ShopRepositoryMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ShopRepositoryMock: ShopRepository {
    var isNeedToReturnError = false
    var isGetShopStarted = false
    
    func getShop(callback: @escaping ApiCallback<Shop>) {
        isGetShopStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.shop, nil)
    }
}
