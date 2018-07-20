//
//  Author+Details.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 6/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

extension Author {
    var fullName: String {
        let authorNameLocalized = "Label.FullName".localizable
        return String.localizedStringWithFormat(authorNameLocalized, firstName, lastName)
    }
}
