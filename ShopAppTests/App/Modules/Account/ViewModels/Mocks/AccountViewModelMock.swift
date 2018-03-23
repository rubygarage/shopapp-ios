//
//  AccountViewModelMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class AccountViewModelMock: AccountViewModel {
    var isCustomerLoadingStarted = false
    var isPoliciesLoadingStarted = false
    var isLogoutStarted = false
    var isNeedToReturnCustomer = false
    
    override func loadCustomer() {
        isCustomerLoadingStarted = true
        
        if isNeedToReturnCustomer {
            customer.value = Customer()
        }
    }
    
    override func loadPolicies() {
        isPoliciesLoadingStarted = true
        
        policies.value = [Policy()]
    }
    
    override func logout() {
        isLogoutStarted = true
        
        customer.value = nil
    }
}
