//
//  DeleteAddressUseCase.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class DeleteAddressUseCase {
    private let repository: CustomerRepository

    init(repository: CustomerRepository) {
        self.repository = repository
    }

    func deleteCustomerAddress(id: String, callback: @escaping RepoCallback<Bool>) {
        repository.deleteCustomerAddress(id: id, callback: callback)
    }
}
