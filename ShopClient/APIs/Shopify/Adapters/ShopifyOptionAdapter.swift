//
//  ShopifyOptionAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyProductOptionAdapter: ProductOption {
    init(option: Storefront.ProductOption) {
        super.init()
        
        id = option.id.rawValue
        name = option.name
        values = option.values
    }
}
