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
        } else if card.name?.holderNameValid() == false {
            return NSLocalizedString("Error.InvalidHolderName", comment: String())
        } else if card.expiresDateValid() == false {
            return NSLocalizedString("Error.InvalidExpiresDate", comment: String())
        }
        return nil
    }
}

private extension String {
    func luhnValid() -> Bool {
        var sum = 0
        let reversedCharacters = self.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
    func holderNameValid() -> Bool {
        return components(separatedBy: " ").count > 1
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
