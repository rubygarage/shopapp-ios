//
//  Customer+Details.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

extension Customer {
    var fullName: String {
        if let first = firstName, first.isEmpty == false, let last = lastName, last.isEmpty == false {
            let customerNameLocalized = "Label.FullName".localizable
            return String.localizedStringWithFormat(customerNameLocalized, first, last)
        } else {
            return email
        }
    }
}
