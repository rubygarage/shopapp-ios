//
//  UpdateAddressUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

struct UpdateAddressUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        repository.updateCustomerAddress(with: address, callback: callback)
    }
}
