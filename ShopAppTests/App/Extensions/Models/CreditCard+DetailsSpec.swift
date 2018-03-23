//
//  CreditCard+DetailsSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CreditCard_DetailsSpec: QuickSpec {
    override func spec() {
        describe("when masked number used") {
            it("needs to return correct formatted string") {
                let creditCard = CreditCard()
                creditCard.cardNumber = "123 456 789 0123"
                
                let maskedNumberLocalized = "Label.CreditCard.MaskedNumber".localizable
                let maskedNumber = String(creditCard.cardNumber.suffix(4))
                
                expect(creditCard.maskedNumber) == String.localizedStringWithFormat(maskedNumberLocalized, creditCard.cardTypeName, maskedNumber)
            }
        }
        
        describe("when holder name used") {
            it("needs to return correct formatted string") {
                let creditCard = CreditCard()
                creditCard.firstName = "First"
                creditCard.lastName = "Last"
                
                let holderNameLocalized = "Label.FullName".localizable
                
                expect(creditCard.holderName) == String.localizedStringWithFormat(holderNameLocalized, creditCard.firstName, creditCard.lastName)
            }
        }
        
        describe("when expiration date localized used") {
            it("needs to return correct formatted string") {
                let creditCard = CreditCard()
                creditCard.expireMonth = "12"
                creditCard.expireYear = "1234"
                
                let expireLocalized = "Label.CreditCard.ExpirationDate".localizable
                let expireYearShort = String(creditCard.expireYear.suffix(2))
                
                expect(creditCard.expirationDateLocalized) == String.localizedStringWithFormat(expireLocalized, creditCard.expireMonth, expireYearShort)
            }
        }
        
        describe("when card type name used") {
            it("needs to return correct formatted string") {
                let creditCard = CreditCard()
                creditCard.cardNumber = "4242424242424242"
                
                expect(creditCard.cardTypeName) == CreditCardValidator.cardTypeName(for: creditCard.cardNumber)
            }
        }
        
        describe("when card image name used") {
            it("needs to return correct formatted string") {
                let creditCard = CreditCard()
                creditCard.cardNumber = "4242424242424242"
                
                expect(creditCard.cardImageName) == CreditCardValidator.cardImageName(for: creditCard.cardNumber)
            }
        }
    }
}
