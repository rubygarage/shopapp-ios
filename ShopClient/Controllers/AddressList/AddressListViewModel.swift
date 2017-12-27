//
//  AddressListViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class AddressListViewModel: BaseViewModel {
    var customerAddresses = Variable<[Address]>([Address]())
    
    // MARK: - public
    public func loadCustomerAddresses() {
        state.onNext(.loading(showHud: true))
        Repository.shared.getCustomer { [weak self] (customer, error) in
            if let addresses = customer?.addresses {
                self?.customerAddresses.value = addresses
                self?.state.onNext(.content)
            } else if let error = error {
                self?.state.onNext(.error(error: error))
            }
        }
    }
}
