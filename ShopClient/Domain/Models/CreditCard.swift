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
    
    private var types: [CreditCardValidationType] {
        return [(name: "Amex", regex: "^3[47][0-9]{5,}$", image: #imageLiteral(resourceName: "card_type_amex")),
                (name: "Visa", regex: "^4\\d{0,}$", image: #imageLiteral(resourceName: "card_type_visa")),
                (name: "MasterCard", regex: "^5[1-5]\\d{0,14}$", image: #imageLiteral(resourceName: "card_type_master_card")),
                (name: "Diners Club", regex: "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$", image: #imageLiteral(resourceName: "card_type_dc_card")),
                (name: "JCB", regex: "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$", image: #imageLiteral(resourceName: "card_type_jcb_card")),
                (name: "Discover", regex: "^6(?:011|5[0-9]{2})[0-9]{3,}$", image: #imageLiteral(resourceName: "card_type_discover"))]
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
    
    var cardTypeImage: UIImage? {
        return type(for: cardNumber)?.image
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
