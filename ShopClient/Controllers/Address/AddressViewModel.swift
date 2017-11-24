//
//  CardValidationViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class AddressViewModel: BaseViewModel {
    var emailText = Variable<String>("")
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var addressText = Variable<String>("")
    var cityText = Variable<String>("")
    var countryText = Variable<String>("")
    var zipText = Variable<String>("")
    var phoneText = Variable<String>("")
    
    private var requiredTextFields: [Observable<String>] {
        get {
            return [emailText, firstNameText, lastNameText, addressText, cityText, countryText, zipText].map({ $0.asObservable() })
        }
    }
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(requiredTextFields, { (textFields) in
            let allNotEmpty = textFields.map({ $0.isEmpty == false }).filter({ $0 == false }).count == 0 // or .filter({ $0 == true }).count == textFields.count
            let emailIndex = textFields.index(of: self.emailText.value) ?? 0
            let validEmail = textFields[emailIndex].isValidAsEmail()
            return allNotEmpty && validEmail
        })
    }
 
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
    
    /*
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), firstNameText.asObservable(), lastNameText.asObservable(), addressText.asObservable(), cityText.asObservable(), countryText.asObservable(), zipText.asObservable(), phoneText.asObservable()) { email, firstName, lastName, address, city, country, zip, phone in
            
            // TODO:
            return true
        }
    }
 */
}
