//
//  ShopifyProductAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyProductAdapter {
    static func adapt(item: Storefront.Product?, currencyValue: String?) -> Product? {
        return adapt(item: item, currencyValue: currencyValue, isShortVariant: false)
    }

    static func adapt(item: Storefront.ProductEdge?, currencyValue: String?) -> Product? {
        let product = adapt(item: item?.node, currencyValue: currencyValue, isShortVariant: true)
        product?.paginationValue = item?.cursor
        return product
    }

    private static func adapt(item: Storefront.Product?, currencyValue: String?, isShortVariant: Bool) -> Product? {
        guard let item = item else {
            return nil
        }

        let product = Product()
        product.id = item.id.rawValue
        product.title = item.title
        product.productDescription = item.description
        product.currency = currencyValue
        product.discount = ""
        product.type = item.productType
        product.vendor = item.vendor
        product.createdAt = item.createdAt
        product.updatedAt = item.updatedAt
        product.tags = item.tags
        product.additionalDescription = item.descriptionHtml

        let imagesNodes = item.images.edges.map({ $0.node })
        var imagesArray: [Image] = []
        for imageNode in imagesNodes {
            if let image = ShopifyImageAdapter.adapt(item: imageNode) {
                imagesArray.append(image)
            }
        }
        product.images = imagesArray

        let variantsNodes = item.variants.edges.map({ $0.node })
        var variantsArray: [ProductVariant] = []
        for variantNode in variantsNodes {
            if let variant = ShopifyProductVariantAdapter.adapt(item: variantNode, productId: item.id, productImage: item.images.edges.first?.node, isShortVariant: isShortVariant) {
                variantsArray.append(variant)
            }
        }

        if !isShortVariant {
            product.variants = variantsArray
        } else {
            let variantsPrices = variantsArray.map { $0.price ?? 0.0 }.sorted(by: { $0 < $1 })
            product.price = variantsPrices.first
            product.hasAlternativePrice = variantsPrices.min() ?? 0.0 != variantsPrices.max() ?? 0.0
        }

        let optionsNodes = item.options
        var optionsArray: [ProductOption] = []
        for optionNode in optionsNodes {
            if let option = ShopifyProductOptionAdapter.adapt(item: optionNode) {
                optionsArray.append(option)
            }
        }
        product.options = optionsArray

        if let options = product.options, options.count == 1 && options.first?.values?.count == 1 {
            product.variants?.forEach {
                $0.title = ""
            }
        }
        return product
    }
}
