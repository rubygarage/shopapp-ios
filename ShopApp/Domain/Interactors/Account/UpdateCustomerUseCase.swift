//
//  UpdateCustomerUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class UpdateCustomerUseCase {
    private var repository: CustomerRepository
    
    init(repository: CustomerRepository) {
        self.repository = repository
    }

    func updateCustomerSettings(isAcceptMarketing: Bool, _ callback: @escaping ApiCallback<Void>) {
        repository.updateCustomerSettings(isAcceptMarketing: isAcceptMarketing, callback: callback)
    }
    
    func updateCustomer(firstName: String, lastName: String, phone: String, _ callback: @escaping ApiCallback<Customer>) {
        repository.updateCustomer(firstName: firstName, lastName: lastName, phone: phone, callback: callback)
    }
    
    func updatePassword(password: String, _ callback: @escaping ApiCallback<Void>) {
        repository.updatePassword(password: password, callback: callback)
    }
}
