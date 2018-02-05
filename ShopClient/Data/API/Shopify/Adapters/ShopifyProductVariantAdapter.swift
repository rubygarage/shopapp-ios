//
//  ShopifyProductVariantAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension ProductVariant {
    convenience init?(with item: Storefront.ProductVariant?, productId: GraphQL.ID?, productImage: Storefront.Image?, isShortVariant: Bool = false) {
        guard let item = item else {
            return nil
        }
        self.init()
        
        guard !isShortVariant else {
            price = item.price
            return
        }
        
        id = item.id.rawValue
        title = item.title
        price = item.price
        available = item.availableForSale
        image = Image(with: item.image) ?? Image(with: productImage)
        let selectedOptions = item.selectedOptions
        var selectedOptionsArray = [VariantOption]()
        for selectedOption in selectedOptions {
            if let variantOption = VariantOption(variantObject: selectedOption) {
                selectedOptionsArray.append(variantOption)
            }
        }
        self.selectedOptions = selectedOptionsArray
        if let productId = productId?.rawValue {
            self.productId = productId
        }
    }
}
