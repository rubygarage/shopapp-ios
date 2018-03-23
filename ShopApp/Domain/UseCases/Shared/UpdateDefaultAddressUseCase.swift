//
//  UpdateDefaultAddressUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class UpdateDefaultAddressUseCase {
    private let repository: PaymentsRepository

    init(repository: PaymentsRepository) {
        self.repository = repository
    }

    func updateDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        repository.updateCustomerDefaultAddress(with: addressId, callback: callback)
    }
}
