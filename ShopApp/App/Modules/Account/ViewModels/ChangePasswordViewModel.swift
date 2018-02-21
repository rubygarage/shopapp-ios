//
//  ChangePasswordViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

class ChangePasswordViewModel: BaseViewModel {
    private var updateCustomerUseCase: UpdateCustomerUseCase
    
    var newPasswordText = Variable<String>("")
    var confirmPasswordText = Variable<String>("")
    var newPasswordErrorMessage = PublishSubject<String>()
    var confirmPasswordErrorMessage = PublishSubject<String>()
    var updateSuccess = PublishSubject<Bool>()
    
    var updateButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(newPasswordText.asObservable(), confirmPasswordText.asObservable()) { (newEmail, confirmPassword) in
            newEmail.hasAtLeastOneSymbol() && confirmPassword.hasAtLeastOneSymbol()
        }
    }
    var updatePressed: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.checkValidation()
            default:
                break
            }
        }
    }
    
    init(updateCustomerUseCase: UpdateCustomerUseCase) {
        self.updateCustomerUseCase = updateCustomerUseCase
    }
    
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
        state.onNext(ViewState.make.loading(isTranslucent: true))
        updateCustomerUseCase.updateCustomer(with: newPasswordText.value) { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if customer != nil {
                strongSelf.state.onNext(.content)
            }
            strongSelf.updateSuccess.onNext(error == nil && customer != nil)
        }
    }
}
