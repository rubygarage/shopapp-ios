//
//  AddressRequest.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct AddressRequest: Request {
    let id: Int?
    let countryId: String
    let firstName: String
    let lastName: String
    let streets: [String]
    let city: String
    let regionId: Int?
    let postcode: String
    let telephone: String
    let isDefaultAddress: Bool
    
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
        self.id = id
        self.countryId = countryId
        self.firstName = firstName
        self.lastName = lastName
        self.streets = streets
        self.city = city
        self.regionId = regionId
        self.postcode = postcode
        self.telephone = telephone
        self.isDefaultAddress = isDefaultAddress
    }
    
    static func update(_ request: AddressRequest, isDefaultAddress: Bool) -> AddressRequest {
        return AddressRequest(id: request.id, countryId: request.countryId, firstName: request.firstName, lastName: request.lastName, streets: request.streets, city: request.city, regionId: request.regionId, postcode: request.postcode, telephone: request.telephone, isDefaultAddress: isDefaultAddress)
    }
}
