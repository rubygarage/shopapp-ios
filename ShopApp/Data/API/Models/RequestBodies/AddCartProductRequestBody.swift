//
//  AddCartProductRequestBody.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 6/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct AddCartProductRequestBody: RequestBody {
    var id: String
    var quantity: String
    var quoteId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "sku"
        case quantity = "qty"
        case quoteId = "quote_id"
    }
}
