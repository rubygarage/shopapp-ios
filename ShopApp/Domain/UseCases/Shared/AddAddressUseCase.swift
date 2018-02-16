//
//  AddAddressUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

class AddAddressUseCase {
    private lazy var repository = AppDelegate.getRepository()

    func addAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        repository.addCustomerAddress(with: address, callback: callback)
    }
}
