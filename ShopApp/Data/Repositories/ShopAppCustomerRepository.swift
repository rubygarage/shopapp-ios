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
    
    func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomer(with: email, firstName: firstName, lastName: lastName, phone: phone, callback: callback)
    }
    
    func updateCustomer(with promo: Bool, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomer(with: promo, callback: callback)
    }
    
    func updateCustomer(with password: String, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomer(with: password, callback: callback)
    }
    
    func addCustomerAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        api.addCustomerAddress(with: address, callback: callback)
    }
    
    func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        api.updateCustomerAddress(with: address, callback: callback)
    }
    
    func updateCustomerDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        api.updateCustomerDefaultAddress(with: addressId, callback: callback)
    }
    
    func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        api.deleteCustomerAddress(with: addressId, callback: callback)
    }
}
