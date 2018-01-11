//
//  ShopifyProductOptionAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension ProductOption {
    convenience init?(with item: Storefront.ProductOption?) {
        if item == nil {
            return nil
        }
        self.init()
        
        id = item?.id.rawValue ?? ""
        name = item?.name
        values = item?.values
    }
}
