//
//  UpdateDefaultAddressUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

struct UpdateDefaultAddressUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func updateDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        repository.updateCustomerDefaultAddress(with: addressId, callback: callback)
    }
}
