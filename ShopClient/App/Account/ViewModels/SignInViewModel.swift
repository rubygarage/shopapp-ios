//
//  SignInViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignInViewModel: BaseViewModel {
    var emailText = Variable<String>("")
    var passwordText = Variable<String>("")
    var emailErrorMessage = PublishSubject<String>()
    var passwordErrorMessage = PublishSubject<String>()
    var signInSuccess = Variable<Bool>(false)
    
    var delegate: AuthenticationProtocol!
    
    var signInButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) { email, password in
            email.hasAtLeastOneSymbol() && password.hasAtLeastOneSymbol()
        }
    }
    
    var loginPressed: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.checkCresentials()
        }
    }
    
    private let loginUseCase = LoginUseCase()
    
    private func checkCresentials() {
        if emailText.value.isValidAsEmail() && passwordText.value.isValidAsPassword() {
            signIn()
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
    
    private func signIn() {
        state.onNext(.loading(showHud: true))
        loginUseCase.login(with: emailText.value, password: passwordText.value) { [weak self] (success, error) in
            if let success = success {
                self?.notifyAboutSignInResult(success: success)
                self?.state.onNext(.content)
            }
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
        }
    }
    
    private func notifyAboutSignInResult(success: Bool) {
        if success {
            delegate?.didAuthorize()
        }
        signInSuccess.value = success
    }
}
