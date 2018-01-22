//
//  ForgotPasswordViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class ForgotPasswordViewModel: BaseViewModel {
    private let resetPasswordUseCase = ResetPasswordUseCase()
    
    var emailText = Variable<String>("")
    var emailErrorMessage = PublishSubject<String>()
    var resetPasswordSuccess = Variable<Bool>(false)
    
    var resetPasswordButtonEnabled: Observable<Bool> {
        return emailText.asObservable().map { email in
            email.hasAtLeastOneSymbol()
        }
    }
    var resetPasswordPressed: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.checkCresentials()
        }
    }
    
    // MARK: - Private
    
    private func checkCresentials() {
        if emailText.value.isValidAsEmail() {
            resetPassword()
        } else {
            processErrors()
        }
    }
    
    private func processErrors() {
        let errorMessage = "Error.InvalidEmail".localizable
        emailErrorMessage.onNext(errorMessage)
    }
    
    private func resetPassword() {
        state.onNext(.loading(showHud: true))
        resetPasswordUseCase.resetPassword(with: emailText.value) { [weak self] (success, error) in
            if let success = success {
                self?.notifyAboutResetPassword(success: success)
                self?.state.onNext(.content)
            }
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
        }
    }
    
    private func notifyAboutResetPassword(success: Bool) {
        resetPasswordSuccess.value = success
    }
}
