//
//  ResetPasswordViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class ResetPasswordViewModel: BaseViewModel {
    var emailText = Variable<String>(String())
    var emailErrorMessage = PublishSubject<String>()
    var resetPasswordSuccess = Variable<Bool>(false)
    
    var resetPasswordButtonEnabled: Observable<Bool> {
        return emailText.asObservable().map { email in
            email.hasAtLeastOneSymbol()
        }
    }
    
    var resetPasswordPressed: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.checkCresentials()
        }
    }
    
    private let resetPasswordUseCase = ResetPasswordUseCase()
    
    private func checkCresentials() {
        if emailText.value.isValidAsEmail() {
            resetPassword()
        } else {
            processErrors()
        }
    }
    
    private func processErrors() {
        let errorMessage = NSLocalizedString("Error.InvalidEmail", comment: String())
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
