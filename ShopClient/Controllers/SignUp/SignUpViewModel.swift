//
//  SignUpViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

let kPasswordCharactersCountMin = 6

class SignUpViewModel: BaseViewModel {
    var emailText = Variable<String>(String())
    var firstNameText = Variable<String>(String())
    var lastNameText = Variable<String>(String())
    var passwordText = Variable<String>(String())
    var phoneText = Variable<String>(String())
    
    var signInSuccess = Variable<Bool>(false)
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) { email, password in
            email.isValidAsEmais() && password.characters.count >= kPasswordCharactersCountMin
        }
    }
    
    var signUpPressed: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.signUp()
        }
    }
    
    private func signUp() {
        state.onNext((.loading, nil))
        Repository.shared.signUp(with: emailText.value, firstName: firstNameText.value.orNil(), lastName: lastNameText.value.orNil(), password: passwordText.value, phone: phoneText.value.orNil(), callback: { [weak self] (success, error) in
            if let success = success {
                self?.signInSuccess.value = success
                self?.state.onNext((.content, nil))
            }
            if let error = error {
                self?.state.onNext((.error, error))
            }
        })
    }
}

internal extension String {
    func isValidAsEmais() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func orNil() -> String? {
        return self.isEmpty ? nil : self
    }
}
