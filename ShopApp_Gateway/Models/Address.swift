//
//  Address.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/24/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Address: Equatable {
    public let id: String
    public let street: String
    public let secondStreet: String?
    public let city: String
    public let country: Country
    public let state: State?
    public let firstName: String
    public let lastName: String
    public let zip: String
    public let phone: String?
    
    public init(id: String, firstName: String, lastName: String, street: String, secondStreet: String? = nil, city: String, country: Country, state: State? = nil, zip: String, phone: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.street = street
        self.secondStreet = secondStreet
        self.city = city
        self.country = country
        self.state = state
        self.zip = zip
        self.phone = phone
    }
    
    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.id == rhs.id
            && lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
            && lhs.street == rhs.street
            && lhs.secondStreet == rhs.secondStreet
            && lhs.city == rhs.city
            && lhs.country == rhs.country
            && lhs.state == rhs.state
            && lhs.zip == rhs.zip
            && lhs.phone == rhs.phone
    }
}
