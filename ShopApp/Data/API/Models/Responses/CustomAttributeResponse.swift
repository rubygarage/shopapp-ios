//
//  CustomAttribute.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

struct CustomAttributeResponse: Response {
    var attributeCode: String
    var value: AttributeValueResponse
    
    enum CodingKeys: String, CodingKey {
        case attributeCode = "attribute_code"
        case value
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attributeCode = try values.decode(String.self, forKey: .attributeCode)
        value = AttributeValueResponse()
        
        if let data = try? values.decode(String.self, forKey: .value) {
            value.data = data
        } else if let dataList = try? values.decode([String].self, forKey: .value) {
            value.dataList = dataList
        }
    }
}
