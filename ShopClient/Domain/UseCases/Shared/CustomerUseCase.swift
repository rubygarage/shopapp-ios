//
//  CustomerUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct CustomerUseCase {
    public func getCustomer(_ callback: @escaping RepoCallback<Customer>) {
        Repository.shared.getCustomer(callback: callback)
    }
    
    public func addAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        Repository.shared.addCustomerAddress(with: address, callback: callback)
    }
    
    public func updateDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        Repository.shared.updateCustomerDefaultAddress(with: addressId, callback: callback)
    }
}
