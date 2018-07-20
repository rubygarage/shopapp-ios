//
//  CartProductResponse.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 6/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct CartProductResponse: Response {
    let id: String
    let title: String
    let price: Int
    let quantity: Int
    let cartProductId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "sku"
        case title = "name"
        case price
        case quantity = "qty"
        case cartProductId = "item_id"
    }
}
