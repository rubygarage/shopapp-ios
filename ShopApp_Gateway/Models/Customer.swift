//
//  Customer.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Customer {
    public let id: String
    public let email: String
    public let firstName: String
    public let lastName: String
    public let phone: String?
    public let isAcceptsMarketing: Bool
    public let addresses: [Address]
    public let defaultAddress: Address?

    public init(id: String, email: String, firstName: String, lastName: String, phone: String? = nil, isAcceptsMarketing: Bool, defaultAddress: Address? = nil, addresses: [Address]) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.isAcceptsMarketing = isAcceptsMarketing
        self.defaultAddress = defaultAddress
        self.addresses = addresses
    }
}
