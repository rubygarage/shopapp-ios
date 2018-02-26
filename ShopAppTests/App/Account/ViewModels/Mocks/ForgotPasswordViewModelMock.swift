//
//  ForgotPasswordViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

@testable import ShopApp

class ForgotPasswordViewModelMock: ForgotPasswordViewModel {
    func makeForgotPasswordButtonEnabled() {
        emailText.value = "u"
    }
    
    func makeForgotPasswordButtonDisabled() {
        emailText.value = ""
    }
    
    func makeNotValidEmailText() {
        emailText.value = "user@mail"
        resetPasswordPressed.onNext()
    }
    
    func makeSuccessResetPassword() {
        emailText.value = "user@mail.com"
        resetPasswordPressed.onNext()
    }
}
