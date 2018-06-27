//
//  MagentoCartProductAdapter.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 6/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct MagentoCartProductAdapter {
    static func adapt(_ response: CartProductResponse, currency: String) -> CartProduct {
        let cartProduct = CartProduct()
        cartProduct.productId = response.id
        cartProduct.productTitle = response.title
        cartProduct.currency = currency
        cartProduct.quantity = response.quantity
        cartProduct.cartItemId = String(response.cartProductId)
        
        let productVariant = ProductVariant()
        productVariant.id = response.id
        productVariant.productId = response.id
        productVariant.price = Decimal(response.price)
        cartProduct.productVariant = productVariant
        
        return cartProduct
    }
}
