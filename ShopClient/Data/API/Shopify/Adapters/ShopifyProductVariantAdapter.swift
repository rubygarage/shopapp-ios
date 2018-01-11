//
//  ShopifyProductVariantAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension ProductVariant {
    convenience init?(with item: Storefront.ProductVariant?, productImage: Storefront.Image?) {
        if item == nil {
            return nil
        }
        self.init()
        
        id = item?.id.rawValue ?? ""
        title = item?.title
        price = item?.price.description
        available = item?.availableForSale ?? false
        image = Image(with: item?.image) ?? Image(with: productImage)
        if let selectedOptionsObjects = item?.selectedOptions {
            var selectedOptionsArray = [VariantOption]()
            for selectedOption in selectedOptionsObjects {
                if let variantOption = VariantOption(variantObject: selectedOption) {
                    selectedOptionsArray.append(variantOption)
                }
            }
            selectedOptions = selectedOptionsArray
        }
    }
}
