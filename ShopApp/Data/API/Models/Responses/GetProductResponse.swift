//
//  GetProductResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GetProductResponse: Response {
    var id: Int
    var sku: String
    var name: String
    var attributeSetId: Int
    var price: Double
    var createdAt: Date
    var updatedAt: Date
    var customAttributes: [CustomAttributeResponse]
    var mediaGalleryEntries: [GalleryEntryResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sku
        case name
        case attributeSetId = "attribute_set_id"
        case price
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case customAttributes = "custom_attributes"
        case mediaGalleryEntries = "media_gallery_entries"
    }
}
