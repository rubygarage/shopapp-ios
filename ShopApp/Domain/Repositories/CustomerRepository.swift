//
//  CustomerRepository.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 3/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

protocol CustomerRepository {
    func getCustomer(callback: @escaping RepoCallback<Customer>)

    func updateCustomer(firstName: String, lastName: String, phone: String, callback: @escaping RepoCallback<Customer>)

    func updateCustomerSettings(isAcceptMarketing: Bool, callback: @escaping RepoCallback<Customer>)

    func updatePassword(password: String, callback: @escaping RepoCallback<Customer>)

    func addCustomerAddress(address: Address, callback: @escaping RepoCallback<String>)

    func updateCustomerAddress(address: Address, callback: @escaping RepoCallback<Bool>)

    func setDefaultShippingAddress(id: String, callback: @escaping RepoCallback<Customer>)

    func deleteCustomerAddress(id: String, callback: @escaping RepoCallback<Bool>)
}
