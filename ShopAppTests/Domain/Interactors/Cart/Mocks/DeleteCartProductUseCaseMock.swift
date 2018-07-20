//
//  DeleteCartProductUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class DeleteCartProductUseCaseMock: DeleteCartProductUseCase {
    var isNeedToReturnError = false
    
    override func deleteCartProduct(cartItemId: String, _ callback: @escaping ApiCallback<Void>) {
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
}
