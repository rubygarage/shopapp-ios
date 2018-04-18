//
//  GalleryEntryResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GalleryEntryResponse: Response {
    var id: Int
    var mediaType: String
    var label: String?
    var file: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case label
        case file
    }
}
