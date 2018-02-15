//
//  ShopifyProductVariantAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyProductVariantAdapter {
    static func adapt(item: Storefront.ProductVariant?, productId: GraphQL.ID?, productImage: Storefront.Image?, isShortVariant: Bool = false) -> ProductVariant? {
        guard let item = item else {
            return nil
        }

        let productVariant = ProductVariant()

        guard !isShortVariant else {
            productVariant.price = item.price
            return productVariant
        }

        productVariant.id = item.id.rawValue
        productVariant.title = item.title
        productVariant.price = item.price
        productVariant.available = item.availableForSale
        productVariant.image = ShopifyImageAdapter.adapt(item: item.image) ?? ShopifyImageAdapter.adapt(item: productImage)
        
        let selectedOptions = item.selectedOptions
        var selectedOptionsArray: [VariantOption] = []
        for selectedOption in selectedOptions {
            if let variantOption = ShopifyVariantOptionAdapter.adapt(item: selectedOption) {
                selectedOptionsArray.append(variantOption)
            }
        }
        productVariant.selectedOptions = selectedOptionsArray
        if let productId = productId?.rawValue {
            productVariant.productId = productId
        }

        return productVariant
    }
}
