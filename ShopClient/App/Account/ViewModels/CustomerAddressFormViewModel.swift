//
//  CustomerAddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopClient_Gateway

class CustomerAddressFormViewModel: BaseViewModel {
    private let addAddressUseCase = AddAddressUseCase()
    private let updateAddressUseCase = UpdateAddressUseCase()
    
    var filledAddress = PublishSubject<Address>()
    
    func addCustomerAddress(with address: Address) {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        addAddressUseCase.addAddress(with: address) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.state.onNext(.content)
                strongSelf.filledAddress.onNext(address)
            }
        }
    }
    
    func updateCustomerAddress(with address: Address) {
        state.onNext(ViewState.make.loading(isTranslucent: true))
        updateAddressUseCase.updateCustomerAddress(with: address) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.state.onNext(.content)
                strongSelf.filledAddress.onNext(address)
            }
        }
    }
}
