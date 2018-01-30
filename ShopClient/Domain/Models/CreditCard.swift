//
//  CreditCard.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

typealias CreditCardValidationType = (name: String, regex: String)

private let kMaskedNumberCountMax = 4
private let kExpireYearShortCountMax = 2

class CreditCard: NSObject {
    var firstName = String()
    var lastName = String()
    var cardNumber = String()
    var expireMonth = String()
    var expireYear = String()
    var verificationCode = String()
    
    private var types: [CreditCardValidationType] {
        return [(name: "Amex", regex: "^3[47][0-9]{5,}$"),
                (name: "Visa", regex: "^4\\d{0,}$"),
                (name: "MasterCard", regex: "^5[1-5]\\d{0,14}$"),
                (name: "Maestro", regex: "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"),
                (name: "Diners Club", regex: "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"),
                (name: "JCB", regex: "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"),
                (name: "Discover", regex: "^6(?:011|5[0-9]{2})[0-9]{3,}$"),
                (name: "UnionPay", regex: "^62[0-5]\\d{13,16}$"),
                (name: "Mir", regex: "^22[0-9]{1,14}$")]
    }
    
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
        return type(for: cardNumber)?.name ?? ""
    }
    
    private func type(for: String) -> CreditCardValidationType? {
        for type in types {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.regex)
            if predicate.evaluate(with: cardNumber) {
                return type
            }
        }
        return nil
    }    
}
