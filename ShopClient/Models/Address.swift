//
//  Address.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Address: NSObject {
    var firstName: String?
    var lastName: String?
    var address: String?
    var secondAddress: String?
    var city: String?
    var country: String?
    var state: String?
    var zip: String?
    var phone: String?
    
    var fullname: String {
        return "\(firstName ?? String()) \(lastName ?? String())"
    }
    
    var fullAddress: String {
        var result = String()
        for addressPart in [address, secondAddress, city, zip, country] {
            if let text = addressPart {
                result += result.isEmpty ? text : text.asPart()
            }
        }
        return result
    }
}

internal extension String {
    func asPart() -> String {
        return ", \(self)"
    }
}
