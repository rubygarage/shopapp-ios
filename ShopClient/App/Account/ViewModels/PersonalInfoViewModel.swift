//
//  PersonalInfoViewModel.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift

class PersonalInfoViewModel: BaseViewModel {
    private let loginUseCase = LoginUseCase()
    private let customerUseCase = CustomerUseCase()
    private let updateCustomUseCase = UpdateCustomUseCase()
    
    var canChangeEmail = true
    var customer = Variable<Customer?>(nil)
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var emailText = Variable<String>("")
    var phoneText = Variable<String>("")
    var emailErrorMessage = PublishSubject<String>()
    var saveChangesSuccess = PublishSubject<Bool>()
    
    var saveChangesButtonEnabled: Observable<Bool> {
        let observable = Observable.combineLatest(firstNameText.asObservable(), lastNameText.asObservable(), emailText.asObservable(), phoneText.asObservable()) { [weak self] (firstName, lastName, email, phone) -> Bool in
            guard let strongSelf = self, let customer = strongSelf.customer.value else {
                return false
            }
            let firstNameIsDifferent = customer.firstName ?? "" != firstName
            let lastNameIsDifferent = customer.lastName ?? "" != lastName
            let emailIsDifferent = customer.email != email
            let emailIsValid = email.hasAtLeastOneSymbol()
            let phoneIsDifferent = customer.phone ?? "" != phone
            return firstNameIsDifferent || lastNameIsDifferent || (strongSelf.canChangeEmail && emailIsDifferent && emailIsValid) || phoneIsDifferent
        }
        return observable
    }
    var saveChangesPressed: AnyObserver<Void> {
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
    
    func loadCustomer() {
        loginUseCase.getLoginStatus { isLoggedIn in
            if isLoggedIn {
                getCustomer()
            }
        }
    }
    
    private func getCustomer() {
        state.onNext(ViewState.make.loading())
        customerUseCase.getCustomer { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let customer = customer {
                strongSelf.customer.value = customer
                strongSelf.setCustomerToInputs()
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    private func checkValidation() {
        if emailText.value.isValidAsEmail() {
            saveChanges()
        } else {
            processErrorsIfNeeded()
        }
    }
    
    private func processErrorsIfNeeded() {
        guard emailText.value.isValidAsEmail() == false else {
            return
        }
        let errorMessage = "Error.InvalidEmail".localizable
        emailErrorMessage.onNext(errorMessage)
    }
    
    private func saveChanges() {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        updateCustomUseCase.updateCustomer(with: emailText.value, firstName: firstNameText.value.orNil(), lastName: lastNameText.value.orNil(), phone: phoneText.value.orNil()) { [weak self] (customer, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let customer = customer {
                strongSelf.customer.value = customer
                strongSelf.state.onNext(.content)
            }
            strongSelf.saveChangesSuccess.onNext(error == nil && customer != nil)
        }
    }
    
    private func setCustomerToInputs() {
        guard let customer = customer.value else {
            return
        }
        firstNameText.value = customer.firstName ?? ""
        lastNameText.value = customer.lastName ?? ""
        emailText.value = customer.email
        phoneText.value = customer.phone ?? ""
    }
}
