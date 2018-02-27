//
//  CustomerUseCaseMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CustomerUseCaseMock: CustomerUseCase {
    private let customer = Customer()
    private let error = ContentError()
    
    var isNeedToReturnError = false
    
    override func getCustomer(_ callback: @escaping RepoCallback<Customer>) {
        customer.email = "user@mail.com"
        customer.firstName = "First"
        customer.lastName = "Last"
        customer.phone = "+380990000000"
        
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping RepoCallback<Customer>) {
        isNeedToReturnError ? callback(nil, error) : callback(customer, nil)
    }
}
