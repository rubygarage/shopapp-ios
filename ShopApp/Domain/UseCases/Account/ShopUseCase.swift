//
//  PolisiesUseCase.swift
//  ShopClient
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

    func getShop(_ callback: @escaping (_ shop: Shop) -> Void) {
        repository.getShop { (shop, _) in
            if let shop = shop {
                callback(shop)
            }
        }
    }
}
