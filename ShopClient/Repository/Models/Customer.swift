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
    
    var fullname: String {
        let customerNameLocalized = NSLocalizedString("Label.FullName", comment: String())
        return String.localizedStringWithFormat(customerNameLocalized, firstName ?? String(), lastName ?? String())
    }
}
