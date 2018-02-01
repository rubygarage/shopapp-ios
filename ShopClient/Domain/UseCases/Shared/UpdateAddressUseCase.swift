//
//  UpdateAddressUseCase.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 2/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct UpdateAddressUseCase {
    func updateCustomerAddress(with address: Address, callback: @escaping RepoCallback<Bool>) {
        Repository.shared.updateCustomerAddress(with: address, callback: callback)
    }
}
