//
//  GetCategoriesResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/10/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct GetCategoryListResponse: Response {
    let id: Int
    let name: String
    let childrenData: [GetCategoryListResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case childrenData = "children_data"
    }
}
