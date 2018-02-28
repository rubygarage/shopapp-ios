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
    var isUpdateButtonEnabled = Variable<Bool>(true)
    var isResetPasswordPressed = false

    override var updateButtonEnabled: Observable<Bool> {
        return isUpdateButtonEnabled.asObservable()
    }
    override var updatePressed: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.isResetPasswordPressed = true
            default:
                break
            }
        }
    }
    
    func makeNotValidPasswordTexts() {
        newPasswordErrorMessage.onNext("Error.InvalidPassword".localizable)
        confirmPasswordErrorMessage.onNext("Error.InvalidPassword".localizable)
    }
    
    func makeNotEqualsPasswordTexts() {
        confirmPasswordErrorMessage.onNext("Error.PasswordsAreNotEquals".localizable)
    }
    
    func makeChangedPasswordSuccess(_ success: Bool = true) {
        updateSuccess.onNext(success)
    }
}
