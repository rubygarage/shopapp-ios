//
//  ShopifyProductDetailsAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyProductDetailsAdapter: ProductDetails {
    init(product: Storefront.Product?) {
        super.init()
        
        additionalDescription = product?.descriptionHtml ?? String()
        
        var variantsArray = [ProductVariant]()
        if let variantNodes = product?.variants.edges.map({ $0.node }) {
            for variantNode in variantNodes {                
                variantsArray.append(ShopifyProductVariantAdapter(productVariant: variantNode))
            }
        }
        variants = variantsArray
        
        var optionsArray = [ProductOption]()
        if let options = product?.options {
            for option in options {
                optionsArray.append(ShopifyProductOptionAdapter(option: option))
            }
        }
        options = optionsArray
    }
}
