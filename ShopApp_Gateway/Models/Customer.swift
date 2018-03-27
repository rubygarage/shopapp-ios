//
//  Customer.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public class Customer {
    public var email = ""
    public var firstName: String?
    public var lastName: String?
    public var phone: String?
    public var promo: Bool = false
    public var defaultAddress: Address?
    public var addresses: [Address]?

    public init() {}
}
