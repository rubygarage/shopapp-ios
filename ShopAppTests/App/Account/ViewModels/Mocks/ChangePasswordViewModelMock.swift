//
//  ChangePasswordViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

@testable import ShopApp

class ChangePasswordViewModelMock: ChangePasswordViewModel {
    func makeUpdateButtonEnabled() {
        newPasswordText.value = "p"
        confirmPasswordText.value = "p"
    }
    
    func makeUpdateButtonDisabled() {
        newPasswordText.value = ""
        confirmPasswordText.value = ""
    }
    
    func makeNotValidPasswordTexts() {
        newPasswordText.value = "pass"
        confirmPasswordText.value = "pas"
        updatePressed.onNext()
    }
    
    func makeNotEqualsPasswordTexts() {
        newPasswordText.value = "password"
        confirmPasswordText.value = "passwor"
        updatePressed.onNext()
    }
}
