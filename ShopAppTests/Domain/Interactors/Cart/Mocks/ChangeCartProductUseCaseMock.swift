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
    
    override func changeCartProductQuantity(productVariantId: String?, quantity: Int, _ callback: @escaping RepoCallback<Bool>) {
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
}
