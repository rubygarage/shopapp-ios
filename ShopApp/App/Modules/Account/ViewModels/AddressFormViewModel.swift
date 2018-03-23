//
//  AddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class AddressFormViewModel: BaseViewModel {
    private let countriesUseCase: CountriesUseCase
    
    private var countries: [Country] = [] {
        didSet {
            namesOfCountries.onNext(countries.map { $0.name })
        }
    }
    
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
    var namesOfCountries = PublishSubject<[String]>()
    var namesOfStates = PublishSubject<[String]>()
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

    init(countriesUseCase: CountriesUseCase) {
        self.countriesUseCase = countriesUseCase
    }
    
    func getCountries() {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        countriesUseCase.getCountries { [weak self] (countries, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let countries = countries {
                strongSelf.state.onNext(.content)
                strongSelf.countries = countries
            }
        }
    }
    
    func updateStates(with nameOfCountry: String) {
        if let country = countries.filter({ $0.name == nameOfCountry }).first, !country.states.isEmpty {
            namesOfStates.onNext(country.states.map { $0.name })
        } else {
            stateText.value = ""
            namesOfStates.onNext([])
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
