//
//  CustomerUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct CustomerUseCase {
    public func getCustomer(_ callback: @escaping RepoCallback<Customer>) {
        Repository.shared.getCustomer(callback: callback)
    }
}
