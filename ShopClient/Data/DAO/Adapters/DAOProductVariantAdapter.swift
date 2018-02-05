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
        guard let variant = variant else {
            return nil
        }
        self.init()
        
        id = variant.id ?? ""
        price = variant.price?.decimalValue
        title = variant.title
        available = variant.available
        image = Image(with: variant.image)
        productId = variant.productId ?? ""
        selectedOptions = variant.selectedOptions?.map {
            let option = VariantOption()
            if let optionEntity = $0 as? VariantOptionEntity {
                option.name = optionEntity.name ?? ""
                option.value = optionEntity.value ?? ""
            }
            return option
        }
    }
}
