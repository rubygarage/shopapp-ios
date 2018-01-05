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
            if let productVariant = ProductVariant(with: variant, productImage: nil) {
                self.productVariant = productVariant
            }
        }
    }
}
