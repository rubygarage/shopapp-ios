//
//  AddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class AddressFormViewModel: BaseViewModel {
    private let countriesUseCase = CountriesUseCase()
    
    private var requiredTextFields: [Observable<String>] {
        return [countryText, firstNameText, lastNameText, addressText, cityText, zipText, phoneText].map({ $0.asObservable() })
    }
    
    var countryText = Variable<String>("")
    var firstNameText = Variable<String>("")
    var lastNameText = Variable<String>("")
    var addressText = Variable<String>("")
    var addressOptionalText = Variable<String>("")
    var cityText = Variable<String>("")
    var stateText = Variable<String>("")
    var zipText = Variable<String>("")
    var phoneText = Variable<String>("")
    var filledAddress = PublishSubject<Address>()
    var address: Address?
    
    var isAddressValid: Observable<Bool> {
        return Observable.combineLatest(requiredTextFields, { (textFields) in
            return textFields.map({ $0.isEmpty == false }).filter({ $0 == false }).isEmpty
        })
    }
    var submitTapped: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.submitAction()
            default:
                break
            }
        }
    }
    
    func getCountries() {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        countriesUseCase.getCountries { [weak self] (countries, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if countries != nil {
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    func updateFields() {
        guard let address = address else {
            return
        }
        countryText.value = address.country ?? ""
        firstNameText.value = address.firstName ?? ""
        lastNameText.value = address.lastName ?? ""
        addressText.value = address.address ?? ""
        addressOptionalText.value = address.secondAddress ?? ""
        cityText.value = address.city ?? ""
        stateText.value = address.state ?? ""
        zipText.value = address.zip ?? ""
        phoneText.value = address.phone ?? ""
    }
        
    private func submitAction() {
        filledAddress.onNext(getAddress())
    }
 
    private func getAddress() -> Address {
        let address = Address()
        address.id = self.address?.id ?? ""
        address.country = countryText.value.trimmingCharacters(in: .whitespaces)
        address.firstName = firstNameText.value.trimmingCharacters(in: .whitespaces)
        address.lastName = lastNameText.value.trimmingCharacters(in: .whitespaces)
        address.address = addressText.value.trimmingCharacters(in: .whitespaces)
        address.secondAddress = addressOptionalText.value.trimmingCharacters(in: .whitespaces)
        address.city = cityText.value.trimmingCharacters(in: .whitespaces)
        address.state = stateText.value.trimmingCharacters(in: .whitespaces)
        address.zip = zipText.value.trimmingCharacters(in: .whitespaces)
        address.phone = phoneText.value.trimmingCharacters(in: .whitespaces)

        return address
    }
}
