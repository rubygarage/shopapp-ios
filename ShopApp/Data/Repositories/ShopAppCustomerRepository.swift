//
//  ShopAppCustomerRepository.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 3/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class ShopAppCustomerRepository: CustomerRepository {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func getCustomer(callback: @escaping RepoCallback<Customer>) {
        api.getCustomer(callback: callback)
    }
    
    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomer(firstName: firstName, lastName: lastName, phone: phone, callback: callback)
    }
    
    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomerSettings(isAcceptMarketing: isAcceptMarketing, callback: callback)
    }
    
    func updatePassword(password: String, callback: @escaping RepoCallback<Customer>) {
        api.updatePassword(password: password, callback: callback)
    }
    
    func addCustomerAddress(address: Address, callback: @escaping RepoCallback<String>) {
        api.addCustomerAddress(address: address, callback: callback)
    }
    
    func updateCustomerAddress(address: Address, callback: @escaping RepoCallback<Bool>) {
        api.updateCustomerAddress(address: address, callback: callback)
    }
    
    func setDefaultShippingAddress(addressId: String, callback: @escaping RepoCallback<Customer>) {
        api.setDefaultShippingAddress(addressId: addressId, callback: callback)
    }
    
    func deleteCustomerAddress(addressId: String, callback: @escaping RepoCallback<Bool>) {
        api.deleteCustomerAddress(addressId: addressId, callback: callback)
    }
}
