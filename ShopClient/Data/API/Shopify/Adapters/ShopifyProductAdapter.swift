//
//  ShopifyProductAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Product {
    convenience init?(with item: Storefront.Product?, currencyValue: String?) {
        guard let item = item else {
            return nil
        }
        self.init()
        
        update(with: item, currencyValue: currencyValue)
    }
    
    convenience init?(with item: Storefront.ProductEdge?, currencyValue: String?) {
        guard let item = item else {
            return nil
        }
        self.init()
        
        update(with: item.node, currencyValue: currencyValue, isShortVariant: true)
        paginationValue = item.cursor
    }
    
    private func update(with item: Storefront.Product, currencyValue: String?, isShortVariant: Bool = false) {
        id = item.id.rawValue
        title = item.title
        productDescription = item.description
        currency = currencyValue
        discount = ""
        type = item.productType
        vendor = item.vendor
        createdAt = item.createdAt
        updatedAt = item.updatedAt
        tags = item.tags
        additionalDescription = item.descriptionHtml
        
        let imagesNodes = item.images.edges.map({ $0.node })
        var imagesArray = [Image]()
        for imageNode in imagesNodes {
            if let image = Image(with: imageNode) {
                imagesArray.append(image)
            }
        }
        images = imagesArray
        
        let variantsNodes = item.variants.edges.map({ $0.node })
        var variantsArray = [ProductVariant]()
        for variantNode in variantsNodes {
            if let variant = ProductVariant(with: variantNode, productId: item.id, productImage: item.images.edges.first?.node, isShortVariant: isShortVariant) {
                variantsArray.append(variant)
            }
        }
        if !isShortVariant {
            variants = variantsArray
        } else {
            let variantsPrices = variantsArray.map { $0.price ?? 0.0 }.sorted(by: { $0 < $1 })
            price = variantsPrices.first
            hasAlternativePrice = variantsPrices.min() ?? 0.0 != variantsPrices.max() ?? 0.0
        }

        let optionsNodes = item.options
        var optionsArray = [ProductOption]()
        for optionNode in optionsNodes {
            if let option = ProductOption(with: optionNode) {
                optionsArray.append(option)
            }
        }
        options = optionsArray
        
        if let options = options, options.count == 1 && options.first?.values?.count == 1 {
            variants?.forEach {
                $0.title = ""
            }
        }
    }
}
