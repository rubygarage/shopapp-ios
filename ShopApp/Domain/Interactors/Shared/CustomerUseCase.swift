//
//  CustomerUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class CustomerUseCase {
    private let repository: CustomerRepository

    init(repository: CustomerRepository) {
        self.repository = repository
    }

    func getCustomer(_ callback: @escaping RepoCallback<Customer>) {
        repository.getCustomer(callback: callback)
    }
}
