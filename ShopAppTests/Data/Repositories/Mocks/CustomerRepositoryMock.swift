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
    var promo: Bool?
    var password: String?
    var addressId: String?
    var address: Address?
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {
        isGetCustomerStarted = true
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerInfoStarted = true
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomer(with promo: Bool, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerPromoStarted = true
        
        self.promo = promo
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomer(with password: String, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerPasswordStarted = true
        
        self.password = password
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomerDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        isUpdateCustomerDefaultAddressStarted = true
        
        self.addressId = addressId
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback(Customer(), nil)
    }
    
    func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        isUpdateCustomerAddressStarted = true
        
        self.address = address
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
    
    func addCustomerAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        isAddCustomerAddressStarted = true
        
        self.address = address
        
        isNeedToReturnError ? callback(nil, RepoError()) : callback("", nil)
    }
    
    func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        isDeleteCustomerAddressStarted = true
        
        self.addressId = addressId
        
        isNeedToReturnError ? callback(false, RepoError()) : callback(true, nil)
    }
}
