//
//  CountryResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct CountryResponse: Response {
    let id: String
    let name: String
    let regions: [RegionResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "full_name_locale"
        case regions = "available_regions"
    }
}
