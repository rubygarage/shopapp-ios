//
//  CustomerAddressFormViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CustomerAddressFormDelegate: class {
    func viewModelDidUpdateAddress(_ model: CustomerAddressFormViewModel)
}

class CustomerAddressFormViewModel: BaseViewModel {
    private let addAddressUseCase = AddAddressUseCase()
    
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
                strongSelf.delegate?.viewModelDidUpdateAddress(strongSelf)
            }
        }
    }
    
    func updateCustomerAddress(with address: Address, isSelected: Bool) {
        state.onNext(.loading(showHud: true))
        Repository.shared.updateCustomerAddress(with: address) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else {
                strongSelf.state.onNext(.content)
                strongSelf.delegate?.viewModelDidUpdateAddress(strongSelf)
            }
        }
    }
}
