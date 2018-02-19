//
//  CustomerUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class CustomerUseCase {
    private lazy var repository = AppDelegate.getRepository()

    func getCustomer(_ callback: @escaping RepoCallback<Customer>) {
        repository.getCustomer(callback: callback)
    }
}
