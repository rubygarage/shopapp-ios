//
//  AddressResponse.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct AddressResponse: Response {
    let id: Int
    let countryId: String
    let firstName: String
    let lastName: String
    let streets: [String]
    let city: String
    let regionId: Int?
    let postcode: String
    let telephone: String
    let isDefaultAddress: Bool?
    
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
