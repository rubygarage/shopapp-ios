//
//  SignInUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class SignInUseCaseMock: SignInUseCase {
    private let error = ContentError()
    
    var isNeedToReturnError = false
    var isGetLoginStatusStarted = false
    
    override func signIn(email: String, password: String, _ callback: @escaping RepoCallback<Void>) {
        callback((), isNeedToReturnError ? error : nil)
    }
    
    override func isSignedIn(_ callback: @escaping RepoCallback<Bool>) {
        isGetLoginStatusStarted = true
        
        isNeedToReturnError ? callback(nil, error) : callback(true, nil)
    }
}
