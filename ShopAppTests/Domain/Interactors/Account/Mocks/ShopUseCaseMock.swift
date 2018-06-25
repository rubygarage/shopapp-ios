//
//  ShopUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ShopUseCaseMock: ShopUseCase {
    override func getShop(_ callback: @escaping ApiCallback<Shop>) {
        callback(TestHelper.shop, nil)
    }
}
