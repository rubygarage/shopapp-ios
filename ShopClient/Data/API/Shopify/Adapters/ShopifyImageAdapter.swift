//
//  ShopifyImageAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

extension Image {
    convenience init?(with item: Storefront.Image?) {
        if item == nil {
            return nil
        }
        self.init()
    
        id = item?.id?.rawValue ?? ""
        src = item?.src.absoluteString
        imageDescription = item?.altText
    }
}
