//
//  MagentoAdaptersTestHepler.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation
import ShopApp_Gateway

@testable import ShopApp

struct MagentoAdaptersTestHepler {
    static var host: String {
        return "http://host/"
    }
    
    static var regionResponse: RegionResponse {
        return RegionResponse(id: "id", name: "name")
    }
    
    static var countryResponse: CountryResponse {
        return CountryResponse(id: "id", name: "name", regions: [regionResponse])
    }
    
    static var addressResponse: AddressResponse {
        return AddressResponse(id: 0, countryId: "id", firstName: "first", lastName: "last", streets: ["main street", "additional street"], city: "city", regionId: 1, postcode: "postcode", telephone: "telephone", isDefaultAddress: true)
    }
    
    static var zaporozhye: State {
        let zaporozhye = State()
        zaporozhye.id = "ZP"
        zaporozhye.name = "Zaporozhye"
        
        return zaporozhye
    }
    
    static var ukraine: Country {
        let ukraine = Country()
        ukraine.id = "UA"
        ukraine.name = "Ukraine"
        ukraine.states = [zaporozhye]
        
        return ukraine
    }
    
    static var descriptionCustomAttributeResponse: CustomAttributeResponse {
        return CustomAttributeResponse.object(from: ["attribute_code": "description", "value": "description"])!
    }
    
    static var thumbnailCustomAttributeResponse: CustomAttributeResponse {
        return CustomAttributeResponse.object(from: ["attribute_code": "thumbnail", "value": "thumbnail"])!
    }
    
    static var imageCustomAttributeResponse: CustomAttributeResponse {
        return CustomAttributeResponse.object(from: ["attribute_code": "image", "value": "image"])!
    }
}
