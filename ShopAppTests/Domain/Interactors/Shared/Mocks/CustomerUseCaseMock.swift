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
    var isGetCustomerStarted = false
    
    override func getCustomer(_ callback: @escaping RepoCallback<Customer>) {
        customer.email = "user@mail.com"
        customer.firstName = "First"
        customer.lastName = "Last"
        customer.phone = "+380990000000"
        
        let customerAddress = Address()
        customerAddress.id = "Customer address id"
        customerAddress.address = "Address"
        customerAddress.secondAddress = "Second address"
        customerAddress.city = "City"
        customerAddress.zip = "Zip"
        customerAddress.country = "Country"
        customer.addresses = [customerAddress]
        customer.defaultAddress = customerAddress
        
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping RepoCallback<Customer>) {
        isNeedToReturnError ? callback(nil, error) : callback(customer, nil)
        isGetCustomerStarted = true
    }
}
