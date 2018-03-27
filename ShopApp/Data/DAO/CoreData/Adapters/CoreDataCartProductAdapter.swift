//
//  CoreDataCartProductAdapter.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

struct CoreDataCartProductAdapter {
    static func adapt(product: Product?, productQuantity: Int, variant: ProductVariant?) -> CartProduct? {
        guard let product = product else {
            return nil
        }
        
        let cartProduct = CartProduct()
        cartProduct.productId = product.id
        cartProduct.productTitle = product.title
        cartProduct.productVariant = variant
        cartProduct.currency = product.currency
        cartProduct.quantity = productQuantity
        
        return cartProduct
    }
    
    static func adapt(item: CartProductEntity?) -> CartProduct? {
        guard let item = item else {
            return nil
        }
        
        let cartProduct = CartProduct()
        cartProduct.productId = item.productId
        cartProduct.productTitle = item.productTitle
        cartProduct.productVariant = CoreDataProductVariantAdapter.adapt(item: item.productVariant)
        cartProduct.currency = item.currency
        cartProduct.quantity = Int(item.quantity)
        
        return cartProduct
    }
}
