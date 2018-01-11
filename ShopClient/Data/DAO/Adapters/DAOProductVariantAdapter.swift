//
//  DAOProductVariantAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

extension ProductVariant {
    convenience init?(with variant: ProductVariantEntity?) {
        if variant == nil {
            return nil
        }
        self.init()
        
        id = variant?.id ?? ""
        price = variant?.price
        title = variant?.title
        available = variant?.available ?? false
        image = Image(with: variant?.image)
    }
}
