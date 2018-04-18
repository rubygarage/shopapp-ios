//
//  AddressRequestBody.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct AddressRequestBody: RequestBody {
    var id: Int?
    var countryId: String
    var firstName: String
    var lastName: String
    var streets: [String]
    var city: String
    var regionId: Int?
    var postcode: String
    var telephone: String
    var isDefaultAddress: Bool
    
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
    
    init(id: Int? = nil, countryId: String, firstName: String, lastName: String, streets: [String], city: String, regionId: Int? = nil, postcode: String, telephone: String, isDefaultAddress: Bool = false) {
        self.countryId = countryId
        self.firstName = firstName
        self.lastName = lastName
        self.streets = streets
        self.city = city
        self.postcode = postcode
        self.telephone = telephone
        self.isDefaultAddress = isDefaultAddress
        
        if let id = id {
            self.id = id
        }
        
        if let regionId = regionId {
            self.regionId = regionId
        }
    }
}
