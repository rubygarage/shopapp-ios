//
//  ProductModelHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

extension ProductEntity {
    var imagesArray: [ImageEntity]? {
        get {
            let imagesObjects = images?.allObjects as? [ImageEntity]
            return imagesObjects?.sorted(by: { $0.id ?? String() < $1.id ?? String() })
        }
    }
    
    var optionsArray: [ProductOptionEntity]? {
        get {
            return options?.allObjects as? [ProductOptionEntity]
        }
    }
    
    var variantsArray: [ProductVariantEntity]? {
        get {
            return variants?.allObjects as? [ProductVariantEntity]
        }
    }
    
    var lowestPrice: String {
        get {
            return variantsArray?.sorted(by: { $0.price ?? String() < $1.price ?? String() }).first?.price ?? String()
        }
    }
    
    var currency: String {
        get {
            return ShopEntity.mr_findFirst()?.currency ?? String()
        }
    }
}
