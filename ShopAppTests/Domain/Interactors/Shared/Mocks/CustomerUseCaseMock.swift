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
    private let customer = TestHelper.customerWithoutAcceptsMarketing
    private let error = ShopAppError.content(isNetworkError: false)
    
    var isNeedToReturnError = false
    var isGetCustomerStarted = false
    
    override func getCustomer(_ callback: @escaping ApiCallback<Customer>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping ApiCallback<Customer>) {
        isNeedToReturnError ? callback(nil, error) : callback(customer, nil)
        isGetCustomerStarted = true
    }
}
