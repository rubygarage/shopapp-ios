//
//  PersonalInfoViewModel.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class PersonalInfoViewModel: BaseViewModel {
    private let updateCustomerUseCase: UpdateCustomerUseCase
    private let signInUseCase: SignInUseCase
    private let customerUseCase: CustomerUseCase
    
    var customer = Variable<Customer?>(nil)
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var phoneText = Variable<String>("")
    var saveChangesSuccess = PublishSubject<Bool>()
    
    var saveChangesButtonEnabled: Observable<Bool> {
        let observable = Observable.combineLatest(firstNameText.asObservable(), lastNameText.asObservable(), phoneText.asObservable()) { [weak self] (firstName, lastName, phone) -> Bool in
            guard let strongSelf = self, let customer = strongSelf.customer.value else {
                return false
            }
            let firstNameIsDifferent = customer.firstName != firstName
            let lastNameIsDifferent = customer.lastName != lastName
            let phoneIsDifferent = customer.phone ?? "" != phone
            return firstNameIsDifferent || lastNameIsDifferent || phoneIsDifferent
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
                strongSelf.saveChanges()
            default:
                break
            }
        }
    }
    
    init(updateCustomerUseCase: UpdateCustomerUseCase, signInUseCase: SignInUseCase, customerUseCase: CustomerUseCase) {
        self.updateCustomerUseCase = updateCustomerUseCase
        self.signInUseCase = signInUseCase
        self.customerUseCase = customerUseCase
    }
    
    func loadCustomer() {
        signInUseCase.isSignedIn({ [weak self] (isSignedIn, _) in
            guard let strongSelf = self else {
                return
            }

            if let isSignedIn = isSignedIn, isSignedIn {
                strongSelf.getCustomer()
            }
        })
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
    
    private func saveChanges() {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        updateCustomerUseCase.updateCustomer(firstName: firstNameText.value, lastName: lastNameText.value, phone: phoneText.value) { [weak self] (customer, error) in
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
        firstNameText.value = customer.firstName
        lastNameText.value = customer.lastName
        phoneText.value = customer.phone ?? ""
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        saveChanges()
    }
}
