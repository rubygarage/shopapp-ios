//
//  Card.swift
//  ShopApp_Gateway
//
//  Created by Evgeniy Antonov on 11/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

public struct Card: Equatable {
    public let firstName: String
    public let lastName: String
    public let cardNumber: String
    public let expireMonth: String
    public let expireYear: String
    public let verificationCode: String

    public init(firstName: String, lastName: String, cardNumber: String, expireMonth: String, expireYear: String, verificationCode: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.cardNumber = cardNumber
        self.expireMonth = expireMonth
        self.expireYear = expireYear
        self.verificationCode = verificationCode
    }
    
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
            && lhs.cardNumber == rhs.cardNumber
            && lhs.expireMonth == rhs.expireMonth
            && lhs.expireYear == rhs.expireYear
            && lhs.verificationCode == rhs.verificationCode
    }
}
