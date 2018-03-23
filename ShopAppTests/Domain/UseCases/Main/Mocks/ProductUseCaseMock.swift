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
    
    override func getProduct(with id: String, _ callback: @escaping RepoCallback<Product>) {
        isNeedToReturnError ? callback(nil, RepoError()) : callback(returnedValue, nil)
    }
}
