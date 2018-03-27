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
        return String.localizedStringWithFormat(addressNameLocalized, firstName ?? "", lastName ?? "")
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
