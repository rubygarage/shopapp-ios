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
        
        return CartProduct(id: product.id, productVariant: variant, title: product.title, currency: product.currency, quantity: productQuantity)
    }
}
