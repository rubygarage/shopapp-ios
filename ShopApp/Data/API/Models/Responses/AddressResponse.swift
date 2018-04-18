//
//  AddressResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct AddressResponse: Response {
    var id: Int
    var countryId: String
    var firstName: String
    var lastName: String
    var streets: [String]
    var city: String
    var regionId: Int?
    var postcode: String
    var telephone: String
    var isDefaultAddress: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryId = "country_id"
        case firstName = "firstname"
        case lastName = "lastname"
        case streets = "street"
        case city
        case regionId = "region_id"
        case postcode
        case telephone
        case isDefaultAddress = "default_shipping"
    }
}
