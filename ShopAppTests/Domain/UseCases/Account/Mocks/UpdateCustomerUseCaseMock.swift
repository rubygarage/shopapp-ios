//
//  UpdateCustomerUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class UpdateCustomerUseCaseMock: UpdateCustomerUseCase {
    private let customer = Customer()
    private let error = ContentError()
    
    var isNeedToReturnError = false
    
    override func updateCustomer(with promo: Bool, _ callback: @escaping RepoCallback<Customer>) {
        execute(callback: callback)
    }
    
    override func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, _ callback: @escaping RepoCallback<Customer>) {
        execute(callback: callback)
    }
    
    override func updateCustomer(with password: String, _ callback: @escaping RepoCallback<Customer>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping RepoCallback<Customer>) {
        !isNeedToReturnError ? callback(customer, nil) : callback(nil, error)
    }
}
