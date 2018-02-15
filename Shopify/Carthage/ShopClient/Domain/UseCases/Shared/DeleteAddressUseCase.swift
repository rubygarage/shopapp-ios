//
//  DeleteAddressUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

struct DeleteAddressUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        repository.deleteCustomerAddress(with: addressId, callback: callback)
    }
}
