//
//  UpdateCustomUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct UpdateCustomUseCase {
    func updateCustomer(with promo: Bool, _ callback: @escaping RepoCallback<Customer>) {
        Repository.shared.updateCustomer(with: promo, callback: callback)
    }
    
    func updateCustomer(with email: String, firstName: String?, lastName: String?, phone: String?, _ callback: @escaping RepoCallback<Customer>) {
        Repository.shared.updateCustomer(with: email, firstName: firstName, lastName: lastName, phone: phone, callback: callback)
    }
}
