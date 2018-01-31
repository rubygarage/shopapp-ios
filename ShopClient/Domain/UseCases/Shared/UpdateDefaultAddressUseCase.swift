//
//  UpdateDefaultAddressUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct UpdateDefaultAddressUseCase {
    func updateDefaultAddress(with addressId: String, callback: @escaping RepoCallback<Customer>) {
        Repository.shared.updateCustomerDefaultAddress(with: addressId, callback: callback)
    }
}
