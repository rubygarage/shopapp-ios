//
//  Customer.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

class Customer: NSObject {
    var email = String()
    var firstName: String?
    var lastName: String?
    var phone: String?
    var defaultAddress: Address?
    
    var fullname: String {
        if let first = firstName, first.isEmpty == false, let last = lastName, last.isEmpty == false {
            let customerNameLocalized = NSLocalizedString("Label.FullName", comment: String())
            return String.localizedStringWithFormat(customerNameLocalized, first, last)
        } else {
            return email
        }
    }
}
