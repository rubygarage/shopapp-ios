//
//  CardValidationViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class AddressViewModel: BaseViewModel {
    var countryText = Variable<String>("")
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var addressText = Variable<String>("")
    var addressOptionalText = Variable<String>("")
    var cityText = Variable<String>("")
    var stateText = Variable<String>("")
    var zipText = Variable<String>("")
    var phoneText = Variable<String>("")
    
    private var requiredTextFields: [Observable<String>] {
        get {
            return [countryText, firstNameText, lastNameText, addressText, cityText, stateText, zipText, phoneText].map({ $0.asObservable() })
        }
    }
    
    var isAddressValid: Observable<Bool> {
        return Observable.combineLatest(requiredTextFields, { (textFields) in
            return textFields.map({ $0.isEmpty == false }).filter({ $0 == false }).count == 0
        })
    }
    
    var submitTapped: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.submitAction()
        }
    }
    
    private func submitAction() {
        // TODO:
    }
 
    /*
    public func getAddress() -> Address {
        let address = Address()
        address.email = emailText.value
        address.firstName = firstNameText.value
        address.lastName = lastNameText.value
        address.address = addressText.value
        address.city = cityText.value
        address.country = countryText.value
        address.zip = zipText.value
        address.phone = phoneText.value.isEmpty ? nil : phoneText.value
        
        return address
    }
 */
}
