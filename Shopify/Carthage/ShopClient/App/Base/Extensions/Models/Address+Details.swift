//
//  Address+Details.swift
//  ShopClient
//
//  Created by Mykola Voronin on 2/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopClient_Gateway

extension Address {
    var fullName: String {
        let customerNameLocalized = "Label.FullName".localizable
        return String.localizedStringWithFormat(customerNameLocalized, firstName ?? String(), lastName ?? String())
    }

    var fullAddress: String {
        var result = address!
        if let secondAddress = secondAddress, !secondAddress.isEmpty {
            result = [result, secondAddress].joined(separator: ", ")
        }
        let adressParts = [city, zip, country].flatMap { $0 }
        if !adressParts.isEmpty {
            let subresult = adressParts.joined(separator: ", ")
            result = [result, subresult].joined(separator: ", ")
        }
        return result
    }
}
