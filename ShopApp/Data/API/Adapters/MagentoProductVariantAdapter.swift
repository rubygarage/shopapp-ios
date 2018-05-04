//
//  MagentoProductVariantAdapter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct MagentoProductVariantAdapter {
    static func adapt(_ product: Product) -> ProductVariant {
        let productVariant = ProductVariant()
        productVariant.id = product.id
        productVariant.title = product.title
        productVariant.price = product.price
        productVariant.available = true
        productVariant.image = product.images?.first
        productVariant.selectedOptions = []
        productVariant.productId = product.id
        
        return productVariant
    }
}
