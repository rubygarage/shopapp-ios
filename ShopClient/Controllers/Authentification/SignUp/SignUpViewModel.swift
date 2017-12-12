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
    var emailErrorMessage = PublishSubject<String>()
    var passwordErrorMessage = PublishSubject<String>()
    var signUpSuccess = Variable<Bool>(false)
    
    var delegate: AuthenticationProtocol!
    
    var signUpButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) { email, password in
            email.hasAtLeastOneSymbol() && password.hasAtLeastOneSymbol()
        }
    }
    
    var signUpPressed: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.checkCresentials()
        }
    }
    
    private func checkCresentials() {
        if emailText.value.isValidAsEmail() && passwordText.value.isValidAsPassword() {
            signUp()
        } else {
            processErrorsIfNeeded()
        }
    }
    
    private func processErrorsIfNeeded() {
        if emailText.value.isValidAsEmail() == false {
            let errorMessage = NSLocalizedString("Error.InvalidEmail", comment: String())
            emailErrorMessage.onNext(errorMessage)
        }
        if passwordText.value.isValidAsPassword() == false {
            let errorMessage = NSLocalizedString("Error.InvalidPassword", comment: String())
            passwordErrorMessage.onNext(errorMessage)
        }
    }
    
    private func signUp() {
        state.onNext(.loading(showHud: true))
        Repository.shared.signUp(with: emailText.value, firstName: firstNameText.value.orNil(), lastName: lastNameText.value.orNil(), password: passwordText.value, phone: phoneText.value.orNil(), callback: { [weak self] (success, error) in
            if let success = success {
                self?.notifyAboutSignUpResult(success: success)
                self?.state.onNext(.content)
            }
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
        })
    }
    
    private func notifyAboutSignUpResult(success: Bool) {
        if success {
            delegate?.didAuthorize()
        }
        signUpSuccess.value = success
    }
}
