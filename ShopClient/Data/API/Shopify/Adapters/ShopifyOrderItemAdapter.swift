//
//  ShopifyOrderIemAdapter.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension OrderItem {
    convenience init?(with item: Storefront.OrderLineItem?) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item)
    }
    
    private func update(with item: Storefront.OrderLineItem?) {
        quantity = Int(item?.quantity ?? 0)
        title = item?.title
        
        if let variant = item?.variant {
            if let productVariant = ProductVariant(with: variant, productId: variant.product.id, productImage: variant.product.images.edges.first?.node) {
                self.productVariant = productVariant
                if variant.product.options.count == 1 && variant.product.options.first?.values.count == 1 {
                    self.productVariant?.selectedOptions = nil
                }
            }
        }
    }
}
