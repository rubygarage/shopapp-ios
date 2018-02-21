//
//  DeleteAddressUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class DeleteAddressUseCase {
    private let repository: PaymentsRepository

    init(repository: PaymentsRepository) {
        self.repository = repository
    }

    func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        repository.deleteCustomerAddress(with: addressId, callback: callback)
    }
}
