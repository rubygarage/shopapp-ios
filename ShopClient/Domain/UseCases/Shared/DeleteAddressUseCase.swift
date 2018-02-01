//
//  DeleteAddressUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct DeleteAddressUseCase {
    func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        Repository.shared.deleteCustomerAddress(with: addressId, callback: callback)
    }
}
