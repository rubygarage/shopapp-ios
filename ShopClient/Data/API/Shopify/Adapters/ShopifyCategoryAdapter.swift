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
        
        update(with: item, currencyValue: currencyValue, productsListNeeded: true)
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
    
    private func update(with item: Storefront.Collection?, currencyValue: String?, productsListNeeded: Bool = false) {
        id = item?.id.rawValue ?? ""
        title = item?.title
        categoryDescription = item?.description
        image = Image(with: item?.image)
        updatedAt = item?.updatedAt
        if productsListNeeded {
            updateCategoryProducts(with: item, currencyValue: currencyValue)
        }
    }
    
    private func updateCategoryProducts(with item: Storefront.Collection?, currencyValue: String?) {
        if let productsEdges = item?.products.edges {
            var productsArray = [Product]()
            for productEdge in productsEdges {
                if let product = Product(with: productEdge, currencyValue: currencyValue) {
                    productsArray.append(product)
                }
            }
            products = productsArray
        }
    }
}
