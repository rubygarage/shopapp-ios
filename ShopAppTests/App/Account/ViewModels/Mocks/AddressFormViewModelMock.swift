//
//  AddressFormViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class AddressFormViewModelMock: AddressFormViewModel {
    var addressValid = Variable<Bool>(false)
    var submitButtonDidPress = false
    
    override var isAddressValid: Observable<Bool> {
        return addressValid.asObservable()
    }
    override var submitTapped: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.submitButtonDidPress = true
            default:
                break
            }
        }
    }
    
    func makeSubmitAction() {
        let address = Address()
        filledAddress.onNext(address)
    }
    
    func makeNameOfCountries(with countryNames: [String]) {
        namesOfCountries.onNext(countryNames)
    }
    
    func makeNameOfStates(with stateNames: [String]) {
        namesOfStates.onNext(stateNames)
    }
}
