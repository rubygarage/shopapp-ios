//
//  PolisiesUseCase.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

struct ShopUseCase {
    public func getShop(_ callback: @escaping (_ shop: Shop) -> Void) {
        Repository.shared.getShop { (shop, _) in
            if let shop = shop {
                callback(shop)
            }
        }
    }
}
