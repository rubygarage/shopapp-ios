//
//  ShopifyCartProductAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

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
}
