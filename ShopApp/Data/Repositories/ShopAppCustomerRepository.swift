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
    
    func getCustomer(callback: @escaping ApiCallback<Customer>) {
        api.getCustomer(callback: callback)
    }
    
    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping ApiCallback<Customer>) {
        api.updateCustomer(firstName: firstName, lastName: lastName, phone: phone, callback: callback)
    }
    
    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping ApiCallback<Void>) {
        api.updateCustomerSettings(isAcceptMarketing: isAcceptMarketing, callback: callback)
    }
    
    func updatePassword(password: String, callback: @escaping ApiCallback<Void>) {
        api.updatePassword(password: password, callback: callback)
    }
    
    func addCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>) {
        api.addCustomerAddress(address: address, callback: callback)
    }
    
    func updateCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>) {
        api.updateCustomerAddress(address: address, callback: callback)
    }
    
    func setDefaultShippingAddress(id: String, callback: @escaping ApiCallback<Void>) {
        api.setDefaultShippingAddress(id: id, callback: callback)
    }
    
    func deleteCustomerAddress(id: String, callback: @escaping ApiCallback<Void>) {
        api.deleteCustomerAddress(id: id, callback: callback)
    }
}
