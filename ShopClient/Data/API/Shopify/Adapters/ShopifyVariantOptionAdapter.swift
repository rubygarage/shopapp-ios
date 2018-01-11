//
//  ShopifyVariantOptionAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/6/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension VariantOption {
    convenience init?(variantObject: Storefront.SelectedOption?) {
        if variantObject == nil {
            return nil
        }
        self.init()
        
        name = variantObject?.name ?? ""
        value = variantObject?.value ?? ""
    }
}
