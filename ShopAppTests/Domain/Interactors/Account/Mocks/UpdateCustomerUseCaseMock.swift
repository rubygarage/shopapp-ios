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
    
    override func updateCustomerSettings(isAcceptMarketing: Bool, _ callback: @escaping RepoCallback<Void>) {
        execute(callback: callback)
    }
    
    override func updateCustomer(firstName: String, lastName: String, phone: String, _ callback: @escaping RepoCallback<Customer>) {
        isNeedToReturnError ? callback(nil, error) : callback(customer, nil)
    }
    
    override func updatePassword(password: String, _ callback: @escaping RepoCallback<Void>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping RepoCallback<Void>) {
        callback((), isNeedToReturnError ? error : nil)
    }
}
