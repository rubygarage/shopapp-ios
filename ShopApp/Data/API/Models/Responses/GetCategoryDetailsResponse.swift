//
//  GetCategoryDetailsResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/10/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GetCategoryDetailsResponse: Response {
    var id: Int
    var name: String
    var customAttributes: [CustomAttributeResponse]
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case customAttributes = "custom_attributes"
        case updatedAt = "updated_at"
    }
}
