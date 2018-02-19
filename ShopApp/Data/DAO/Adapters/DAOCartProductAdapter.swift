//
//  ShopifyCartProductAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import ShopApp_Gateway

extension CartProduct {
    convenience init?(with product: Product?, productQuantity: Int, variant: ProductVariant?) {
        let initCondition = product != nil && variant != nil
        if !initCondition {
            return nil
        }
        self.init()
        
        productId = product?.id
        productTitle = product?.title
        productVariant = variant
        currency = product?.currency
        quantity = productQuantity
    }
    
    convenience init?(with item: CartProductEntity?) {
        if item == nil {
            return nil
        }
        self.init()
        
        productId = item?.productId
        productTitle = item?.productTitle
        productVariant = ProductVariant(with: item?.productVariant)
        currency = item?.currency
        quantity = Int(item?.quantity ?? 1)
    }
}
