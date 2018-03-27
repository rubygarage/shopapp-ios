//
//  UpdateAddressUseCase.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class UpdateAddressUseCase {
    private let repository: CustomerRepository

    init(repository: CustomerRepository) {
        self.repository = repository
    }

    func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        repository.updateCustomerAddress(with: address, callback: callback)
    }
}
