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
        var result = address!
        if let secondAddress = secondAddress, !secondAddress.isEmpty {
            result = [result, secondAddress].joined(separator: "\n")
        }
        let adressParts = [city, zip, country].flatMap { $0 }
        if !adressParts.isEmpty {
            let subresult = adressParts.joined(separator: ", ")
            result = [result, subresult].joined(separator: "\n")
        }
        return result
    }
}

internal extension String {
    func asPart() -> String {
        return ", \(self)"
    }
}
