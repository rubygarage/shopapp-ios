//
//  CartValidationUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 4/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CartValidationUseCaseMock: CartValidationUseCase {
    var isNeedToReturnError = false
    
    override func getProductVariantList(ids: [String], _ callback: @escaping RepoCallback<[ProductVariant]>) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback([], nil)
    }
}
