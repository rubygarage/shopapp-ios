//
//  ShopifyCategoryAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyCategoryAdapter {
    static func adapt(item: Storefront.Collection?, currencyValue: String?) -> ShopClient_Gateway.Category? {
        let category = adapt(item: item, currencyValue: currencyValue, withProducts: true)
        category?.additionalDescription = item?.descriptionHtml
        return category
    }

    static func adapt(item: Storefront.CollectionEdge?, currencyValue: String?) -> ShopClient_Gateway.Category? {
        let category = adapt(item: item?.node, currencyValue: currencyValue, withProducts: false)
        category?.paginationValue = item?.cursor
        return category
    }

    // MARK: - Private

    private static func adapt(item: Storefront.Collection?, currencyValue: String?, withProducts: Bool) -> ShopClient_Gateway.Category? {
        guard let item = item else {
            return nil
        }

        let category = Category()
        category.id = item.id.rawValue
        category.title = item.title
        category.categoryDescription = item.description
        category.image = ShopifyImageAdapter.adapt(item: item.image)
        category.updatedAt = item.updatedAt

        if withProducts {
            var productsArray: [Product] = []
            for productEdge in item.products.edges {
                if let product = ShopifyProductAdapter.adapt(item: productEdge, currencyValue: currencyValue) {
                    productsArray.append(product)
                }
            }
            category.products = productsArray
        }
        return category
    }
}

