//
//  BillingAddressViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class BillingAddressViewModel: BaseViewModel {
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var addressText = Variable<String>("")
    var cityText = Variable<String>("")
    var countryText = Variable<String>("")
    var zipText = Variable<String>("")
    var phoneText = Variable<String>("")
    
    var useSameAddress = Variable<Bool>(true)
    var usedAddress = Variable<Address?>(nil)
    
    var preloadedAddress: Address!
    var newAddress = Address()
    
    private var requiredTextFields: [Observable<String>] {
        get {
            return [firstNameText, lastNameText, addressText, cityText, countryText, zipText].map({ $0.asObservable() })
        }
    }
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(requiredTextFields, { [weak self] (textFields) in
            let allTextFieldsValid = textFields.map({ $0.isEmpty == false }).filter({ $0 == false }).count == 0
            return self?.useSameAddress.value ?? false ? true : allTextFieldsValid
        })
    }
    
    var useSameAddressChanged: AnyObserver<Bool> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next(let value):
                self?.updateAddresses(with: value)
            default:
                break
            }
        }
    }
    
    public func getAddress() -> Address {
        return useSameAddress.value ? preloadedAddress : newAddress
    }
    
    private func updateAddresses(with value: Bool) {
        if value {
            newAddress.firstName = firstNameText.value
            newAddress.lastName = lastNameText.value
            newAddress.address = addressText.value
            newAddress.city = cityText.value
            newAddress.country = countryText.value
            newAddress.zip = zipText.value
            newAddress.phone = phoneText.value.isEmpty ? nil : phoneText.value
        }
        self.useSameAddress.value = value
        self.usedAddress.value = value ? self.preloadedAddress : self.newAddress
    }
}
