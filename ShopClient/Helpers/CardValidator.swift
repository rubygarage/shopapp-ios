//
//  CreditCardValidator.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MFCard

class CardValidator: NSObject {
    public class func validate(card: Card) -> String? {
        if card.number?.luhnValid() == false {
            return NSLocalizedString("Error.InvalidCardNumber", comment: String())
        } else if card.name?.isValidAsHolderName() == false {
            return NSLocalizedString("Error.InvalidHolderName", comment: String())
        } else if card.expiresDateValid() == false {
            return NSLocalizedString("Error.InvalidExpiresDate", comment: String())
        }
        return nil
    }
}

private extension Card {
    func expiresDateValid() -> Bool {
        let year = Int(self.year ?? "0") ?? 0
        let month = Int(self.month?.rawValue ?? "0") ?? 0
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        
        return date > Date()
    }
}
