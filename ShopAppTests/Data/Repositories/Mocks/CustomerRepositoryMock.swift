//
//  CustomerRepositoryMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

@testable import ShopApp

class CustomerRepositoryMock: CustomerRepository {
    var isNeedToReturnError = false
    var isGetCustomerStarted = false
    var isUpdateCustomerInfoStarted = false
    var isUpdateCustomerPromoStarted = false
    var isUpdateCustomerPasswordStarted = false
    var isUpdateCustomerDefaultAddressStarted = false
    var isUpdateCustomerAddressStarted = false
    var isAddCustomerAddressStarted = false
    var isDeleteCustomerAddressStarted = false
    var email: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var isAcceptMarketing: Bool?
    var password: String?
    var addressId: String?
    var address: Address?
    
    func getCustomer(callback: @escaping ApiCallback<Customer>) {
        isGetCustomerStarted = true
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.customerWithoutAcceptsMarketing, nil)
    }
    
    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping ApiCallback<Customer>) {
        isUpdateCustomerInfoStarted = true
        
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback(TestHelper.customerWithoutAcceptsMarketing, nil)
    }
    
    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping ApiCallback<Void>) {
        isUpdateCustomerPromoStarted = true
        
        self.isAcceptMarketing = isAcceptMarketing
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback((), nil)
    }
    
    func updatePassword(password: String, callback: @escaping ApiCallback<Void>) {
        isUpdateCustomerPasswordStarted = true
        
        self.password = password
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback((), nil)
    }
    
    func setDefaultShippingAddress(id: String, callback: @escaping ApiCallback<Void>) {
        isUpdateCustomerDefaultAddressStarted = true
        
        self.addressId = id
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback((), nil)
    }
    
    func updateCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>) {
        isUpdateCustomerAddressStarted = true
        
        self.address = address
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
    
    func addCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>) {
        isAddCustomerAddressStarted = true
        
        self.address = address
        
        isNeedToReturnError ? callback(nil, ShopAppError.content(isNetworkError: false)) : callback((), nil)
    }
    
    func deleteCustomerAddress(id: String, callback: @escaping ApiCallback<Void>) {
        isDeleteCustomerAddressStarted = true
        
        addressId = id
        
        callback((), isNeedToReturnError ? ShopAppError.content(isNetworkError: false) : nil)
    }
}
