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
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {
        isGetCustomerStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerInfoStarted = true
        
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping RepoCallback<Void>) {
        isUpdateCustomerPromoStarted = true
        
        self.isAcceptMarketing = isAcceptMarketing
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback((), nil)
    }
    
    func updatePassword(password: String, callback: @escaping RepoCallback<Void>) {
        isUpdateCustomerPasswordStarted = true
        
        self.password = password
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback((), nil)
    }
    
    func setDefaultShippingAddress(id: String, callback: @escaping RepoCallback<Void>) {
        isUpdateCustomerDefaultAddressStarted = true
        addressId = id
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback((), nil)
    }
    
    func updateCustomerAddress(address: Address, callback: @escaping RepoCallback<Void>) {
        isUpdateCustomerAddressStarted = true
        
        self.address = address
        
        callback((), isNeedToReturnError ? RepoError() : nil)
    }
    
    func addCustomerAddress(address: Address, callback: @escaping RepoCallback<Void>) {
        isAddCustomerAddressStarted = true
        
        self.address = address
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback((), nil)
    }
    
    func deleteCustomerAddress(id: String, callback: @escaping RepoCallback<Void>) {
        isDeleteCustomerAddressStarted = true
        addressId = id
        
        callback((), isNeedToReturnError ? RepoError() : nil)
    }
}
