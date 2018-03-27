//
//  SignInViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignInViewModel: BaseViewModel {
    private let loginUseCase: LoginUseCase
    
    var emailText = Variable<String>("")
    var passwordText = Variable<String>("")
    var emailErrorMessage = PublishSubject<String>()
    var passwordErrorMessage = PublishSubject<String>()
    var signInSuccess = PublishSubject<Bool>()
        
    var signInButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) { (email, password) in
            email.hasAtLeastOneSymbol() && password.hasAtLeastOneSymbol()
        }
    }
    var loginPressed: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.checkCredentials()
            default:
                break
            }
        }
    }

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    private func checkCredentials() {
        if emailText.value.isValidAsEmail() && passwordText.value.isValidAsPassword() {
            signIn()
        } else {
            processErrorsIfNeeded()
        }
    }
    
    private func processErrorsIfNeeded() {
        if emailText.value.isValidAsEmail() == false {
            let errorMessage = "Error.InvalidEmail".localizable
            emailErrorMessage.onNext(errorMessage)
        }
        if passwordText.value.isValidAsPassword() == false {
            let errorMessage = "Error.InvalidPassword".localizable
            passwordErrorMessage.onNext(errorMessage)
        }
    }
    
    private func signIn() {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        loginUseCase.login(with: emailText.value, password: passwordText.value) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success {
                strongSelf.state.onNext(.content)
                strongSelf.signInSuccess.onNext(success)
            }
        }
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        checkCredentials()
    }
}
