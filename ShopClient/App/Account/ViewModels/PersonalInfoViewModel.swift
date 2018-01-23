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
    
    var customer = Variable<Customer?>(nil)
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var emailText = Variable<String>("")
    var phoneText = Variable<String>("")
    var emailErrorMessage = PublishSubject<String>()
    var saveChangesSuccess = PublishSubject<Bool>()
    
    var saveChangesButtonEnabled: Observable<Bool> {
        let observable = Observable.combineLatest(firstNameText.asObservable(), lastNameText.asObservable(), emailText.asObservable(), phoneText.asObservable()) { [weak self] (firstName, lastName, email, phone) -> Bool in
            guard let customer = self?.customer.value else {
                return false
            }
            let firstNameIsDifferent = customer.firstName != firstName
            let lastNameIsDifferent = customer.lastName != lastName
            let emailIsDifferent = customer.email != email
            let emailIsValid = email.hasAtLeastOneSymbol()
            let phoneIsDifferent = customer.phone != phone
            return firstNameIsDifferent || lastNameIsDifferent || (emailIsDifferent && emailIsValid) || phoneIsDifferent
        }
        return observable
    }
    var saveChangesPressed: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.checkValidation()
        }
    }
    
    // MARK: - Private
    
    private func getCustomer() {
        state.onNext(.loading(showHud: true))
        customerUseCase.getCustomer { [weak self] (customer, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let customer = customer {
                self?.customer.value = customer
                self?.setCustomerToInputs()
                self?.state.onNext(.content)
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
        if emailText.value.isValidAsEmail() == false {
            let errorMessage = "Error.InvalidEmail".localizable
            emailErrorMessage.onNext(errorMessage)
        }
    }
    
    private func saveChanges() {
        guard let customer = customer.value?.copy() as? Customer else {
            return
        }
        setInputsToCustomer(customer)
        state.onNext(.loading(showHud: true))
        updateCustomUseCase.updateCustomer(customer) { [weak self] (customer, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let customer = customer {
                self?.customer.value = customer
                self?.state.onNext(.content)
            }
            self?.saveChangesSuccess.onNext(error == nil && customer != nil)
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
    
    private func setInputsToCustomer(_ customer: Customer) {
        customer.firstName = firstNameText.value
        customer.lastName = lastNameText.value
        customer.email = emailText.value
        customer.phone = phoneText.value
    }
    
    // MARK: - Internal
    
    func loadCustomer() {
        loginUseCase.getLoginStatus { (isLoggedIn) in
            if isLoggedIn {
                getCustomer()
            }
        }
    }
}
