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
        return ProductVariant(id: product.id, title: product.title, price: product.price, isAvailable: true, image: product.images.first, selectedOptions: [], productId: product.id)
    }
}
