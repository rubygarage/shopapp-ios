//
//  GalleryEntryResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GalleryEntryResponse: Response {
    let id: Int
    let mediaType: String
    let label: String?
    let file: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case label
        case file
    }
}
