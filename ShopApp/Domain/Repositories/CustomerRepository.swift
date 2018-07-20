//
//  CustomerRepository.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 3/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

protocol CustomerRepository {
    func getCustomer(callback: @escaping ApiCallback<Customer>)

    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping ApiCallback<Customer>)

    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping ApiCallback<Void>)

    func updatePassword(password: String, callback: @escaping ApiCallback<Void>)

    func addCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>)

    func updateCustomerAddress(address: Address, callback: @escaping ApiCallback<Void>)

    func setDefaultShippingAddress(id: String, callback: @escaping ApiCallback<Void>)

    func deleteCustomerAddress(id: String, callback: @escaping ApiCallback<Void>)
}
