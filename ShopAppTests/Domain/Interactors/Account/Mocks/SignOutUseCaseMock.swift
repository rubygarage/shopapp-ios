//
//  SignOutUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class SignOutUseCaseMock: SignOutUseCase {
    var isNeedToReturnError = false
    
    override func signOut(_ callback: @escaping ApiCallback<Void>) {
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
}
