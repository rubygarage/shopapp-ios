//
//  PolisiesUseCase.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

class ShopUseCase {
    private let repository: ShopRepository

    init(repository: ShopRepository) {
        self.repository = repository
    }

    func getShop(_ callback: @escaping RepoCallback<Shop>) {
        repository.getShop(callback: callback)
    }
}
