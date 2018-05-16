//
//  AddCartProductUseCaseMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class AddCartProductUseCaseMock: AddCartProductUseCase {
    var isNeedToReturnError = false
    
    override func addCartProduct(_ cartProduct: CartProduct, _ callback: @escaping RepoCallback<Bool>) {
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
}
