//
//  ChangeCartProductUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ChangeCartProductUseCaseMock: ChangeCartProductUseCase {
    var isNeedToReturnError = false
    
    override func changeCartProductQuantity(cartItemId: String?, quantity: Int, _ callback: @escaping ApiCallback<Void>) {
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
}
