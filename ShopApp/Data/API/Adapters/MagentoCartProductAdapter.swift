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
        let price = Decimal(response.price)
        let productVariant = ProductVariant(id: response.id, title: "", price: price, isAvailable: true, selectedOptions: [], productId: response.id)
        
        return CartProduct(id: response.id, productVariant: productVariant, title: response.title, currency: currency, quantity: response.quantity)
    }
    
    static func update(_ cartProduct: CartProduct, with image: Image?) -> CartProduct {
        guard let productVariant = cartProduct.productVariant else {
            return cartProduct
        }
        
        let updatedProductVariant = ProductVariant(id: productVariant.id, title: productVariant.title, price: productVariant.price, isAvailable: productVariant.isAvailable, image: image, selectedOptions: productVariant.selectedOptions, productId: productVariant.productId)
        
        return CartProduct(id: cartProduct.id, productVariant: updatedProductVariant, title: cartProduct.title, currency: cartProduct.currency, quantity: cartProduct.quantity)
    }
}
