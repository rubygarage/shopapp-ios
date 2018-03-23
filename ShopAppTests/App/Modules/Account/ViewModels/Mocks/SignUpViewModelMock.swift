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
    var isSignUpButtonEnabled = Variable<Bool>(true)
    var isSignUpPressed = false
    var isPoliciesLoadingStarted = false
    
    override var signUpButtonEnabled: Observable<Bool> {
        return isSignUpButtonEnabled.asObservable()
    }
    override var signUpPressed: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.isSignUpPressed = true
            default:
                break
            }
        }
    }
    
    override func loadPolicies() {
        isPoliciesLoadingStarted = true
        
        let policies = isNeedToReturnPolicies ? (policy, policy) : (nil, nil)
        self.policies.value = policies
    }
    
    func makeNotValidEmailAndPasswordTexts() {
        emailErrorMessage.onNext("Error.InvalidEmail".localizable)
        passwordErrorMessage.onNext("Error.InvalidPassword".localizable)
    }
    
    func makeSignUpSuccessed() {
        signUpSuccess.onNext(true)
    }
}
