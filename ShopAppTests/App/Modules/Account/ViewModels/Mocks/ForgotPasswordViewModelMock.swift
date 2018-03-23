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
    var isResetPasswordButtonEnabled = Variable<Bool>(true)
    var isResetPasswordPressed = false
    
    override var resetPasswordButtonEnabled: Observable<Bool> {
        return isResetPasswordButtonEnabled.asObservable()
    }
    override var resetPasswordPressed: AnyObserver<Void> {
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
    
    func makeNotValidEmailText() {
        emailErrorMessage.onNext("Error.InvalidEmail".localizable)
    }
    
    func makeResetPasswordSuccess(_ success: Bool = true) {
        resetPasswordSuccess.onNext(success)
    }
}
