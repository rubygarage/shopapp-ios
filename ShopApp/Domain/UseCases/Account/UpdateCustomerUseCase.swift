//
//  UpdateCustomerUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class UpdateCustomerUseCase {
    private var repository: ShopApp_Gateway.AuthentificationRepository
    
    init(repository: ShopApp_Gateway.AuthentificationRepository) {
        self.repository = repository
    }

    func updateCustomer(with promo: Bool, _ callback: @escaping RepoCallback<Customer>) {
        repository.updateCustomer(with: promo, callback: callback)
    }
    
    func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, _ callback: @escaping RepoCallback<Customer>) {
        repository.updateCustomer(with: email, firstName: firstName, lastName: lastName, phone: phone, callback: callback)
    }
    
    func updateCustomer(with password: String, _ callback: @escaping RepoCallback<Customer>) {
        repository.updateCustomer(with: password, callback: callback)
    }
}
