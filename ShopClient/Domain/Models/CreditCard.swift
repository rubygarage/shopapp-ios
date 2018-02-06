//
//  CreditCard.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

typealias CreditCardValidationType = (name: String, regex: String, image: UIImage?)

private let kMaskedNumberCountMax = 4
private let kExpireYearShortCountMax = 2

class CreditCard: NSObject {
    var firstName = String()
    var lastName = String()
    var cardNumber = String()
    var expireMonth = String()
    var expireYear = String()
    var verificationCode = String()
    
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
        return CreditCardValidator.type(for: cardNumber)?.name ?? ""
    }
    
    var cardTypeImage: UIImage? {
        return CreditCardValidator.type(for: cardNumber)?.image
    }
}
