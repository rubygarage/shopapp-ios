//
//  SignUpViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignUpViewModel: BaseViewModel {
    var emailText = Variable<String>("")
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var passwordText = Variable<String>("")
    var phoneText = Variable<String>("")
    
    var signInSuccess = Variable<Bool>(false)
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) { email, password in
            email.isValidAsEmais() && password.isValidAsPassword()
        }
    }
    
    var signUpPressed: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.signUp()
        }
    }
    
    private func signUp() {
        state.onNext(.loading)
        Repository.shared.signUp(with: emailText.value, firstName: firstNameText.value.orNil(), lastName: lastNameText.value.orNil(), password: passwordText.value, phone: phoneText.value.orNil(), callback: { [weak self] (success, error) in
            if let success = success {
                self?.signInSuccess.value = success
                self?.state.onNext(.content)
            }
            if let error = error {
                self?.state.onNext(.error(error))
            }
        })
    }
}
