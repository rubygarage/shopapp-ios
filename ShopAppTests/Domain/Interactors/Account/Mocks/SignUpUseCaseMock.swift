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
    private let error = ContentError()
    
    var isNeedToReturnError = false
    
    override func signUp(firstName: String, lastName: String, email: String, password: String, phone: String, _ callback: @escaping RepoCallback<Bool>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping RepoCallback<Bool>) {
        isNeedToReturnError ? callback(nil, error) : callback(true, nil)
    }
}
