//
//  SignUpUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class SignUpUseCaseMock: SignUpUseCase {
    private let error = ShopAppError.content(isNetworkError: false)
    
    var isNeedToReturnError = false
    
    override func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, _ callback: @escaping ApiCallback<Void>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping ApiCallback<Void>) {
        callback((), isNeedToReturnError ? error : nil)
    }
}
