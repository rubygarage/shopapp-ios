//
//  SignUpViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignUpViewModel: BaseViewModel {
    private let shopUseCase = ShopUseCase()
    private let signUpUseCase = SignUpUseCase()
    
    var emailText = Variable<String>("")
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var passwordText = Variable<String>("")
    var phoneText = Variable<String>("")
    var emailErrorMessage = PublishSubject<String>()
    var passwordErrorMessage = PublishSubject<String>()
    var signUpSuccess = PublishSubject<Bool>()
    var policies = Variable<(privacyPolicy: Policy?, termsOfService: Policy?)>(privacyPolicy: nil, termsOfService: nil)
    
    weak var delegate: AuthenticationProtocol?
    
    var signUpButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) { (email, password) in
            email.hasAtLeastOneSymbol() && password.hasAtLeastOneSymbol()
        }
    }
    var signUpPressed: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.checkCresentials()
        }
    }
    
    func loadPolicies() {
        shopUseCase.getShop { [weak self] shop in
            guard let strongSelf = self, let privacyPolicy = shop.privacyPolicy, privacyPolicy.body?.isEmpty == false, let termsOfService = shop.termsOfService, termsOfService.body?.isEmpty == false else {
                return
            }
            strongSelf.policies.value = (shop.privacyPolicy, shop.termsOfService)
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
            let errorMessage = "Error.InvalidEmail".localizable
            emailErrorMessage.onNext(errorMessage)
        }
        if passwordText.value.isValidAsPassword() == false {
            let errorMessage = "Error.InvalidPassword".localizable
            passwordErrorMessage.onNext(errorMessage)
        }
    }
    
    private func signUp() {
        state.onNext(.loading(showHud: true))
        signUpUseCase.signUp(with: emailText.value, firstName: firstNameText.value.orNil(), lastName: lastNameText.value.orNil(), password: passwordText.value, phone: phoneText.value.orNil()) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success {
                strongSelf.notifyAboutSignUpResult(success: success)
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    private func notifyAboutSignUpResult(success: Bool) {
        if success {
            delegate?.didAuthorize()
        }
        signUpSuccess.onNext(success)
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        checkCresentials()
    }
}
