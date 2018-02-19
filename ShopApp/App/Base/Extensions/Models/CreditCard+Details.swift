//
//  CreditCard+Details.swift
//  ShopClient
//
//  Created by Mykola Voronin on 2/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

typealias CreditCardValidationType = (name: String, regex: String, imageName: String)

private let kMaskedNumberCountMax = 4
private let kExpireYearShortCountMax = 2

extension CreditCard {
    var maskedNumber: String {
        let maskedNumber = String(cardNumber.suffix(kMaskedNumberCountMax))
        let maskedNumberLocalized = "Label.CreditCard.MaskedNumber".localizable
        return String.localizedStringWithFormat(maskedNumberLocalized, cardTypeName, maskedNumber)
    }
    var holderName: String {
        let holderNameLocalized = "Label.FullName".localizable
        return String.localizedStringWithFormat(holderNameLocalized, firstName, lastName)
    }
    var expirationDateLocalized: String {
        let expireLocalized = "Label.CreditCard.ExpirationDate".localizable
        let expireYearShort = String(expireYear.suffix(kExpireYearShortCountMax))
        return String.localizedStringWithFormat(expireLocalized, expireMonth, expireYearShort)
    }
    var cardTypeName: String {
        return CreditCardValidator.cardTypeName(for: cardNumber) ?? ""
    }
    var cardImageName: String {
        return CreditCardValidator.cardImageName(for: cardNumber) ?? ""
    }
}
