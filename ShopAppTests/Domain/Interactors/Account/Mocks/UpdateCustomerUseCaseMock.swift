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
    private let customer = TestHelper.customerWithoutAcceptsMarketing
    private let customerWithAcceptsMarketing = TestHelper.customerWithAcceptsMarketing
    private let error = ShopAppError.content(isNetworkError: false)
    
    var isNeedToReturnError = false
    var isNeedToReturnCustomerWithAcceptsMarketing = false
    
    override func updateCustomerSettings(isAcceptMarketing: Bool, _ callback: @escaping ApiCallback<Void>) {
        execute(callback: callback)
    }
    
    override func updateCustomer(firstName: String, lastName: String, phone: String, _ callback: @escaping ApiCallback<Customer>) {
        execute(callback: callback)
    }
    
    override func updatePassword(password: String, _ callback: @escaping ApiCallback<Void>) {
        execute(callback: callback)
    }
    
    private func execute(callback: @escaping ApiCallback<Customer>) {
        if isNeedToReturnError {
            callback(nil, error)
        } else if isNeedToReturnCustomerWithAcceptsMarketing {
            callback(customerWithAcceptsMarketing, nil)
        } else {
            callback(customer, nil)
        }
    }
    
    private func execute(callback: @escaping ApiCallback<Void>) {
        callback((), isNeedToReturnError ? error : nil)
    }
}
