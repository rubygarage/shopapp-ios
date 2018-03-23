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
    var isSignInButtonEnabled = Variable<Bool>(true)
    var isLoginPressed = false
    
    override var signInButtonEnabled: Observable<Bool> {
        return isSignInButtonEnabled.asObservable()
    }
    override var loginPressed: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.isLoginPressed = true
            default:
                break
            }
        }
    }
    
    func makeNotValidEmailAndPasswordTexts() {
        emailErrorMessage.onNext("Error.InvalidEmail".localizable)
        passwordErrorMessage.onNext("Error.InvalidPassword".localizable)
    }
    
    func makeSignInSuccessed() {
        signInSuccess.onNext(true)
    }
}
