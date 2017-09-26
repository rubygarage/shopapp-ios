//
//  ShopifyProductVariantAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyProductVariantAdapter: ProductVariant {
    init(productVariant: Storefront.ProductVariant ) {
        super.init()
        
        self.id = productVariant.id.rawValue 
        self.title = productVariant.title
        self.price = String(describing: productVariant.price)
        self.available = productVariant.availableForSale 
        if let image = productVariant.image {
            self.image = ShopifyImageAdapter(image: image)
        }
    }
}
