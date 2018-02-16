//
//  DeleteAddressUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

class DeleteAddressUseCase {
    private lazy var repository = AppDelegate.getRepository()

    func deleteCustomerAddress(with addressId: String, callback: @escaping RepoCallback<Bool>) {
        repository.deleteCustomerAddress(with: addressId, callback: callback)
    }
}
