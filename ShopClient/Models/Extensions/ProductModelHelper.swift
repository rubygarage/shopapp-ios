//
//  ProductModelHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

extension Product {
    var imagesArray: [Image]? {
        get {
            let imagesObjects = images?.allObjects as? [Image]
            return imagesObjects?.sorted(by: { $0.id ?? String() < $1.id ?? String() })
        }
    }
    
    var optionsArray: [ProductOption]? {
        get {
            return options?.allObjects as? [ProductOption]
        }
    }
    
    var variantsArray: [ProductVariant]? {
        get {
            return variants?.allObjects as? [ProductVariant]
        }
    }
    
    var lowestPrice: String {
        get {
            return variantsArray?.sorted(by: { $0.price ?? String() < $1.price ?? String() }).first?.price ?? String()
        }
    }
    
    var currency: String {
        get {
            return Shop.mr_findFirst()?.currency ?? String()
        }
    }
}
