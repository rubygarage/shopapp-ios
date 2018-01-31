//
//  AddAddressUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct AddAddressUseCase {
    func addAddress(with address: Address, callback: @escaping RepoCallback<String>) {
        Repository.shared.addCustomerAddress(with: address, callback: callback)
    }
}
