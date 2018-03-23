//
//  PersonalInfoViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/27/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway
import RxSwift

@testable import ShopApp

class PersonalInfoViewModelMock: PersonalInfoViewModel {
    var isSaveChangesButtonEnabled = Variable<Bool>(true)
    var isSaveChangesPressed = false
    var isCustomerLoadingStarted = false
    
    override var saveChangesButtonEnabled: Observable<Bool> {
        return isSaveChangesButtonEnabled.asObservable()
    }
    override var saveChangesPressed: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.isSaveChangesPressed = true
            default:
                break
            }
        }
    }
    
    override func loadCustomer() {
        isCustomerLoadingStarted = true
        
        let customer = Customer()
        customer.email = "user@mail.com"
        customer.firstName = "First"
        customer.lastName = "Last"
        customer.phone = "+380990000000"
        self.customer.value = customer
    }

    func makeNotValidEmailText() {
        emailErrorMessage.onNext("Error.InvalidEmail".localizable)
    }
    
    func makeSaveChangesSuccess(_ success: Bool = true) {
        saveChangesSuccess.onNext(success)
    }
}
