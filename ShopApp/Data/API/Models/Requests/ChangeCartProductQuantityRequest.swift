//
//  ChangeCartProductQuantityRequest.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 6/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct ChangeCartProductQuantityRequest: Request {
    let quantity: String
    let quoteId: String
    
    enum CodingKeys: String, CodingKey {
        case quantity = "qty"
        case quoteId = "quote_id"
    }
}
