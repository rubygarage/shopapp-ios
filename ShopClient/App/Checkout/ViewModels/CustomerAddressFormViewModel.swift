//
//  CustomerAddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CustomerAddressFormDelegate: class {
    func viewModel(_ model: CustomerAddressFormViewModel, didUpdate address: Address)
}

class CustomerAddressFormViewModel: BaseViewModel {
    private let addAddressUseCase = AddAddressUseCase()
    private let updateAddressUseCase = UpdateAddressUseCase()
    
    weak var delegate: CustomerAddressFormDelegate?
    
    func addCustomerAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        addAddressUseCase.addAddress(with: address) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.state.onNext(.content)
                strongSelf.delegate?.viewModel(strongSelf, didUpdate: address)
            }
        }
    }
    
    func updateCustomerAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        updateAddressUseCase.updateCustomerAddress(with: address) { [weak self] (_, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.state.onNext(.content)
                strongSelf.delegate?.viewModel(strongSelf, didUpdate: address)
            }
        }
    }
}
