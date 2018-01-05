//
//  Address.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Address: NSObject {
    var id = String()
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
        let customerNameLocalized = NSLocalizedString("Label.FullName", comment: String())
        return String.localizedStringWithFormat(customerNameLocalized, firstName ?? String(), lastName ?? String())
    }
    
    var fullAddress: String {
        var result = String()
        result += address!
        if let secondAddress = secondAddress {
            result += secondAddress.asSubpart()
        }
        var subresult = String()
        for addressPart in [city, zip, country] {
            if let text = addressPart {
                subresult += subresult.isEmpty ? text : text.asPart()
            }
        }
        result += subresult.asSubpart()
        return result
    }
}

internal extension String {
    func asSubpart() -> String {
        return "\n\(self)"
    }
    
    func asPart() -> String {
        return ", \(self)"
    }
}
