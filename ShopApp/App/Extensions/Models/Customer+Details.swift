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
        guard !firstName.isEmpty && !lastName.isEmpty else {
            return email
        }
        
        let customerNameLocalized = "Label.FullName".localizable
        return String.localizedStringWithFormat(customerNameLocalized, firstName, lastName)
    }
}
