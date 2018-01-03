//
//  CreditCard.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

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
        let maskedNumberLocalized = NSLocalizedString("Label.CreditCard.MaskedNumber", comment: String())
        return String.localizedStringWithFormat(maskedNumberLocalized, maskedNumber)
    }
    
    var holderName: String {
        let holderNameLocalized = NSLocalizedString("Label.FullName", comment: String())
        return String.localizedStringWithFormat(holderNameLocalized, firstName, lastName)
    }
    
    var expirationDateLocalized: String {
        let expireLocalized = NSLocalizedString("Label.CreditCard.ExpirationDate", comment: String())
        let expireYearShort = String(expireYear.suffix(kExpireYearShortCountMax))
        return String.localizedStringWithFormat(expireLocalized, expireMonth, expireYearShort)
    }
}
