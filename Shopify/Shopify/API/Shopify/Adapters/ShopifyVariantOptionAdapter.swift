//
//  ShopifyVariantOptionAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/6/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Buy
import ShopClient_Gateway

struct ShopifyVariantOptionAdapter {
    static func adapt(item: Storefront.SelectedOption?) -> VariantOption? {
        guard let item = item else {
            return nil
        }

        let variantOption = VariantOption()
        variantOption.name = item.name
        variantOption.value = item.value
        return variantOption
    }
}
