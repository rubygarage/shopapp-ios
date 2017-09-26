//
//  ShopifyImageAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK

class ShopifyImageAdapter: Image {
    init(image: Storefront.Image) {
        super.init()
        
        self.id = image.id?.rawValue ?? String()
        self.src = image.src.absoluteString
        self.imageDescription = image.altText ?? String()
    }
}
