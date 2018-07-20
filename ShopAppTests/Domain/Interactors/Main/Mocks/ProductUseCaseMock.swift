//
//  ProductUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class ProductUseCaseMock: ProductUseCase {
    var returnedValue: Product?
    var isNeedToReturnError = false
    
    override func getProduct(id: String, _ callback: @escaping ApiCallback<Product>) {
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(returnedValue, nil)
    }
}
