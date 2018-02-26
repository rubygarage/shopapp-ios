//
//  SignUpViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway
import RxSwift

@testable import ShopApp

class SignUpViewModelMock: SignUpViewModel {
    private let policy = Policy()
    
    var isNeedToReturnPolicies = false
    
    override func loadPolicies() {
        let policies = isNeedToReturnPolicies ? (policy, policy) : (nil, nil)
        self.policies.value = policies
    }
    
    func makeSignUpButtonEnabled() {
        emailText.value = "u"
        passwordText.value = "p"
    }
    
    func makeSignUpButtonDisabled() {
        emailText.value = ""
        passwordText.value = ""
    }
    
    func makeNotValidEmailAndPasswordTexts() {
        emailText.value = "user@mail"
        passwordText.value = "pass"
        signUpPressed.onNext()
    }
    
    func makeSuccessSignUp() {
        emailText.value = "user@mail.com"
        passwordText.value = "password"
        signUpPressed.onNext()
    }
}
