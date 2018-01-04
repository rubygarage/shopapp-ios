//
//  ShopifyOrderIemAdapter.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension OrderItem {
    convenience init?(with item: Storefront.OrderLineItem?, isAllInfoNeeded: Bool) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item, isAllInfoNeeded: isAllInfoNeeded)
    }
    
    private func update(with item: Storefront.OrderLineItem?, isAllInfoNeeded: Bool) {
        quantity = item != nil ? Int(item!.quantity) : 0

        if let variant = item?.variant {
            if let productVariant = ProductVariant(with: variant, productImage: nil) {
                self.productVariant = productVariant
            }
        }
        
        if isAllInfoNeeded {
            title = item?.title
        }
    }
}
