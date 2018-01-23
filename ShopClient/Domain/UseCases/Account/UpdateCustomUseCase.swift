//
//  UpdateCustomUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct UpdateCustomUseCase {
    public func updateCustomer(_ customer: Customer, _ callback: @escaping RepoCallback<Customer>) {
        Repository.shared.updateCustomer(customer, callback: callback)
    }
}
