//
//  ShopifyProductAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Product {
    convenience init?(with item: Storefront.Product?) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item)
    }
    
    convenience init?(with item: Storefront.ProductEdge?) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item?.node)
        paginationValue = item?.cursor
    }
    
    private func update(with item: Storefront.Product?) {
        id = item?.id.rawValue ?? String()
        title = item?.title
        productDescription = item?.description
        currency = String() // TODO:
        discount = String() // TODO:
        type = item?.productType
        vendor = item?.vendor
        createdAt = item?.createdAt
        updatedAt = item?.updatedAt
        tags = item?.tags
        additionalDescription = item?.descriptionHtml
        
        if let imagesNodes = item?.images.edges.map({ $0.node }) {
            var imagesArray = [Image]()
            for imageNode in imagesNodes {
                if let image = Image(with: imageNode) {
                    imagesArray.append(image)
                }
            }
            images = imagesArray
        }
        if let variantsNodes = item?.variants.edges.map({ $0.node }) {
            var variantsArray = [ProductVariant]()
            for variantNode in variantsNodes {
                if let variant = ProductVariant(with: variantNode) {
                    variantsArray.append(variant)
                }
            }
            variants = variantsArray
        }
        if let optionsNodes = item?.options {
            var optionsArray = [ProductOption]()
            for optionNode in optionsNodes {
                if let option = ProductOption(with: optionNode) {
                    optionsArray.append(option)
                }
            }
            options = optionsArray
        }
        if let variantBySelOpts = item?.variantBySelectedOptions {
            self.variantBySelectedOptions = ProductVariant(with: variantBySelOpts)
        }
    }
}
