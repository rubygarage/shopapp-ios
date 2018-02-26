//
//  SignInViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

@testable import ShopApp

class SignInViewModelMock: SignInViewModel {
    func makeSignInButtonEnabled() {
        emailText.value = "u"
        passwordText.value = "p"
    }
    
    func makeSignInButtonDisabled() {
        emailText.value = ""
        passwordText.value = ""
    }
    
    func makeNotValidEmailAndPasswordTexts() {
        emailText.value = "user@mail"
        passwordText.value = "pass"
        loginPressed.onNext()
    }
    
    func makeSuccessSignIn() {
        emailText.value = "user@mail.com"
        passwordText.value = "password"
        loginPressed.onNext()
    }
}
