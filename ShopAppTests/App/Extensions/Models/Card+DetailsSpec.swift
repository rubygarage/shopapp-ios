//
//  Card+DetailsSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class Card_DetailsSpec: QuickSpec {
    override func spec() {
        describe("when masked number used") {
            it("needs to return correct formatted string") {
                let creditCard = TestHelper.card
                let maskedNumberLocalized = "Label.CreditCard.MaskedNumber".localizable
                let maskedNumber = String(creditCard.cardNumber.suffix(4))
                
                expect(creditCard.maskedNumber) == String.localizedStringWithFormat(maskedNumberLocalized, creditCard.cardTypeName, maskedNumber)
            }
        }
        
        describe("when holder name used") {
            it("needs to return correct formatted string") {
                let creditCard = TestHelper.card
                let holderNameLocalized = "Label.FullName".localizable
                
                expect(creditCard.holderName) == String.localizedStringWithFormat(holderNameLocalized, creditCard.firstName, creditCard.lastName)
            }
        }
        
        describe("when expiration date localized used") {
            it("needs to return correct formatted string") {
                let creditCard = TestHelper.card
                let expireLocalized = "Label.CreditCard.ExpirationDate".localizable
                let expireYearShort = String(creditCard.expireYear.suffix(2))
                
                expect(creditCard.expirationDateLocalized) == String.localizedStringWithFormat(expireLocalized, creditCard.expireMonth, expireYearShort)
            }
        }
        
        describe("when card type name used") {
            it("needs to return correct formatted string") {
                let creditCard = TestHelper.card
                
                expect(creditCard.cardTypeName) == CreditCardValidator.cardTypeName(for: creditCard.cardNumber)
            }
        }
        
        describe("when card image name used") {
            it("needs to return correct formatted string") {
                let creditCard = TestHelper.card
                
                expect(creditCard.cardImageName) == CreditCardValidator.cardImageName(for: creditCard.cardNumber)
            }
        }
    }
}
