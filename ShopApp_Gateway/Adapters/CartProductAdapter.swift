//
//  CartProductAdapter.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct CartProductAdapter {
    public static func adapt(product: Product?, productQuantity: Int, variant: ProductVariant?) -> CartProduct? {
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
}
