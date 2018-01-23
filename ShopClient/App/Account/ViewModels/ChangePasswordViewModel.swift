//
//  ChangePasswordViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

class ChangePasswordViewModel: BaseViewModel {
    private let updateCustomUseCase = UpdateCustomUseCase()
    
    var newPasswordText = Variable<String>("")
    var confirmPasswordText = Variable<String>("")
    var newPasswordErrorMessage = PublishSubject<String>()
    var confirmPasswordErrorMessage = PublishSubject<String>()
    var updateSuccess = Variable<Bool>(false)
    
    var updateButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(newPasswordText.asObservable(), confirmPasswordText.asObservable()) { newEmail, confirmPassword in
            newEmail.hasAtLeastOneSymbol() && confirmPassword.hasAtLeastOneSymbol()
        }
    }
    var updatePressed: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.checkValidation()
        }
    }
    
    // MARK: - Private
    
    private func checkValidation() {
        let newPasswordIsValid = newPasswordText.value.isValidAsPassword()
        let confirmPasswordIsValid = confirmPasswordText.value.isValidAsPassword()
        let passwordsAreEquals = newPasswordText.value == confirmPasswordText.value
        if newPasswordIsValid && confirmPasswordIsValid && passwordsAreEquals {
            update()
        } else {
            processErrorsIfNeeded()
        }
    }
    
    private func processErrorsIfNeeded() {
        if newPasswordText.value.isValidAsPassword() == false {
            let errorMessage = "Error.InvalidPassword".localizable
            newPasswordErrorMessage.onNext(errorMessage)
        }
        if confirmPasswordText.value.isValidAsPassword() == false {
            let errorMessage = "Error.InvalidPassword".localizable
            confirmPasswordErrorMessage.onNext(errorMessage)
        } else if newPasswordText.value != confirmPasswordText.value {
            let errorMessage = "Error.PasswordsAreNotEquals".localizable
            confirmPasswordErrorMessage.onNext(errorMessage)
        }
    }
    
    private func update() {
        /*
        state.onNext(.loading(showHud: true))
        updateCustomUseCase.updateCustomer(with: emailText.value, firstName: firstNameText.value.orNil()) { [weak self] (customer, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let customer = customer {
                self?.state.onNext(.content)
            }
            self?.updateSuccess.onNext(error == nil && customer != nil)
        }
 */
    }
}
