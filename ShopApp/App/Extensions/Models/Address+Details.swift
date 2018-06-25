//
//  Address+Details.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

extension Address {
    var fullName: String {
        let addressNameLocalized = "Label.FullName".localizable
        return String.localizedStringWithFormat(addressNameLocalized, firstName, lastName)
    }

    var fullAddress: String {
        var result = [street]
        if let secondAddress = secondStreet, !secondAddress.isEmpty {
            result.append(secondAddress)
        }
        result.append(contentsOf: [city, zip, country])
        return result.joined(separator: ", ")
    }
}
