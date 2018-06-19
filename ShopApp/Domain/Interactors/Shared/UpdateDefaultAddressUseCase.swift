//
//  UpdateDefaultAddressUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class UpdateDefaultAddressUseCase {
    private let repository: CustomerRepository

    init(repository: CustomerRepository) {
        self.repository = repository
    }

    func updateDefaultAddress(id: String, callback: @escaping RepoCallback<Customer>) {
        repository.setDefaultShippingAddress(id: id, callback: callback)
    }
}
