//
//  ShopifyProductAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyProductAdapter: Product {
    init(product: Storefront.Product, cursor: String? = nil, currencyCode: String) {
        super.init()
        
        id = product.id.rawValue
        title = product.title
        productDescription = product.description
        currency = currencyCode
        vendor = product.vendor
        paginationValue = cursor
        vendor = product.vendor
        type = product.productType
        createdAt = product.createdAt
        updatedAt = product.updatedAt
        tags = product.tags
        productDetails = ShopifyProductDetailsAdapter(product: product)
        
        var imagesArray = [Image]()
//        let imageNodes = product.images.edges.map({ $0.node })
//        for imageNode in imageNodes {
//            imagesArray.append(ShopifyImageAdapter(image: imageNode))
//        }
        images = imagesArray

        if let productPrice = product.variants.edges.first?.node.price {
            price = String(describing: productPrice)
        }
    }
}
