//
//  AddAddressUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class AddAddressUseCase {
    private let repository: CustomerRepository

    init(repository: CustomerRepository) {
        self.repository = repository
    }

    func addAddress(address: Address, callback: @escaping RepoCallback<Void>) {
        repository.addCustomerAddress(address: address, callback: callback)
    }
}
