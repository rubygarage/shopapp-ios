//
//  CreditCardAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation
import MFCard

extension CreditCard {
    convenience init?(with card: Card?) {
        if card == nil {
            return nil
        }
        self.init()
        
        let names = card?.name?.split(separator: " ", maxSplits: 1)
        firstName = String(describing: names?.first)
        lastName = String(describing: names?.last)
        cardNumber = card?.number
        expireMonth = card?.month?.rawValue
        expireYear = card?.year
        verificationCode = card?.cvc
    }
}
