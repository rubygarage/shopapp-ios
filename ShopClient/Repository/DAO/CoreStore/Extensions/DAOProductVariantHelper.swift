//
//  DAOProductVariantHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore

extension ProductVariantEntity {
    func update(with item: ProductVariant?, transaction: AsynchronousDataTransaction) {
        id = item?.id
        price = item?.price
        title = item?.title
        available = item?.available ?? false
        
        if let imageItem = item?.image {
            // TODO:
        }
    }
}
