//
//  ShopifyCategoryAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Category {
    convenience init?(with item: Storefront.Collection?, currencyValue: String?) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item, currencyValue: currencyValue)
        additionalDescription = item?.descriptionHtml
    }
    
    convenience init?(with item: Storefront.CollectionEdge?, currencyValue: String?) {
        if item == nil {
            return nil
        }
        self.init()
        
        update(with: item?.node, currencyValue: currencyValue)
        paginationValue = item?.cursor
    }
    
    private func update(with item: Storefront.Collection?, currencyValue: String?) {
        id = item?.id.rawValue ?? String()
        title = item?.title
        categoryDescription = item?.description
        image = Image(with: item?.image)
        updatedAt = item?.updatedAt
        if let productsNodes = item?.products.edges.map({ $0.node }) {
            var productsArray = [Product]()
            for productNode in productsNodes {
                if let product = Product(with: productNode, currencyValue: currencyValue) {
                    productsArray.append(product)
                }
            }
            products = productsArray
        }
    }
}
