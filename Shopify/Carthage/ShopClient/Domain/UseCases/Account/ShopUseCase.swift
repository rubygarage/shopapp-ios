//
//  PolisiesUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopClient_Gateway

struct ShopUseCase {
    private let repository: Repository!

    init() {
        self.repository = nil
    }

    func getShop(_ callback: @escaping (_ shop: Shop) -> Void) {
        repository.getShop { (shop, _) in
            if let shop = shop {
                callback(shop)
            }
        }
    }
}
