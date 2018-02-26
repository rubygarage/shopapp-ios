//
//  LoginUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class LoginUseCaseMock: LoginUseCase {
    private let error = ContentError()
    
    var isNeedToReturnError = false
    
    override func login(with email: String, password: String, _ callback: @escaping RepoCallback<Bool>) {
        execute(callback: callback)
    }
    
    override func getLoginStatus(_ callback: LoginStatusCallback) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping RepoCallback<Bool>) {
        isNeedToReturnError ? callback(nil, error) : callback(true, nil)
    }
    
    private func execute(callback: LoginStatusCallback) {
        isNeedToReturnError ? callback(false) : callback(true)
    }
}
