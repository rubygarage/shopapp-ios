//
//  ShopifyImageAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MobileBuySDK
import ShopClient_Gateway

struct ShopifyImageAdapter {
    static func adapt(item: Storefront.Image?) -> Image? {
        guard let item = item else {
            return nil
        }

        let image = Image()
        image.id = item.id?.rawValue ?? ""
        image.src = item.src.absoluteString
        image.imageDescription = item.altText
        return image
    }
}
