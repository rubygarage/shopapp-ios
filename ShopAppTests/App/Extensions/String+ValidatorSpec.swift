//
//  String+ValidatorSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class String_ValidatorSpec: QuickSpec {
    override func spec() {
        describe("when email checked") {
            context("if email valid") {
                it("should return true") {
                    let email = "test@t.tt"
                    
                    expect(email.isValidAsEmail()) == true
                }
            }
            
            context("and if not valid") {
                it("should return false") {
                    let email1 = "testemail.tt"
                    let email2 = "testemail@t.t"
                    let email3 = "testemail@tt"
                    
                    expect(email1.isValidAsEmail()) == false
                    expect(email2.isValidAsEmail()) == false
                    expect(email3.isValidAsEmail()) == false
                }
            }
        }
        
        describe("when holder name checked") {
            context("if holder name valid") {
                it("should return true") {
                    let holderName1 = "Holder Name"
                    let holderName2 = "Holder Name Test"
                    
                    expect(holderName1.isValidAsHolderName()) == true
                    expect(holderName2.isValidAsHolderName()) == true
                }
            }
            
            context("and if not valid") {
                it("should return false") {
                    let holderName = "HolderName"
                    
                    expect(holderName.isValidAsHolderName()) == false
                }
            }
        }
        
        describe("when password checked") {
            context("if password valid") {
                it("should return true") {
                    let password = "1234567"
                    
                    expect(password.isValidAsPassword()) == true
                }
                
                it("should return true") {
                    let password = "123456"
                    
                    expect(password.isValidAsPassword()) == true
                }
            }
            
            context("and if not valid") {
                it("should return false") {
                    let password = "12345"
                    
                    expect(password.isValidAsPassword()) == false
                }
            }
        }
        
        describe("when card number checked") {
            context("if card number valid") {
                it("should return true") {
                    let cardNumber1 = "1234567890123"
                    let cardNumber2 = "123456789012345"
                    let cardNumber3 = "1234567890123456789"
                    
                    expect(cardNumber1.isValidAsCardNumber()) == true
                    expect(cardNumber2.isValidAsCardNumber()) == true
                    expect(cardNumber3.isValidAsCardNumber()) == true
                }
            }
            
            context("and if not valid") {
                it("should return false") {
                    let cardNumberShort = "123456789012"
                    let cardNumberLong = "12345678901234567890"
                    
                    expect(cardNumberShort.isValidAsCardNumber()) == false
                    expect(cardNumberLong.isValidAsCardNumber()) == false
                }
            }
        }
        
        describe("when cvv checked") {
            context("if cvv valid") {
                it("should return true") {
                    let cvv = "123"
                    
                    expect(cvv.isValidAsCVV()) == true
                }
            }
            
            context("and if not valid") {
                it("should return false") {
                    let cvvShort = "12"
                    let cvvLong = "1234"
                    
                    expect(cvvShort.isValidAsCVV()) == false
                    expect(cvvLong.isValidAsCVV()) == false
                }
            }
        }
        
        describe("when luhn algorithm checked") {
            context("if card valid") {
                it("should return true for American Express") {
                    let amex = "371449635398431"
                    
                    expect(amex.luhnValid()) == true
                }
                
                it("should return true for Visa") {
                    let visa = "4111111111111111"
                    
                    expect(visa.luhnValid()) == true
                }
                
                it("should return true for Master Card") {
                    let masterCard = "5555555555554444"
                    
                    expect(masterCard.luhnValid()) == true
                }
                
                it("should return true for Diners Club") {
                    let dinersClub = "30569309025904"
                    
                    expect(dinersClub.luhnValid()) == true
                }
                
                it("should return true for Discover") {
                    let discover = "6011111111111117"
                    
                    expect(discover.luhnValid()) == true
                }
                
                it("should return true for JCB") {
                    let JCB = "3530111333300000"
                    
                    expect(JCB.luhnValid()) == true
                }
            }
            
            context("and if not valid") {
                it("should return false") {
                    let cardNumber = "4242424242424241"
                    
                    expect(cardNumber.luhnValid()) == false
                }
                
                it("should return false for string with symbols") {
                    let cardNumber = "symbol4242424242"
                    
                    expect(cardNumber.luhnValid()) == false
                }
            }
        }
        
        describe("when is string nil checked") {
            context("if string empty") {
                it("should return nil") {
                    let string = ""
                    
                    expect(string.orNil()).to(beNil())
                }
            }
            
            context("if string not empty") {
                it("should return nil") {
                    let string = "Text"
                    
                    expect(string.orNil()) == string
                }
            }
        }
        
        describe("when string has at least one symbol checked") {
            context("if string not empty") {
                it("should return true") {
                    let string = "Text"
                    
                    expect(string.hasAtLeastOneSymbol()) == true
                }
            }
            
            context("if string not empty") {
                it("should return true") {
                    let string = ""
                    
                    expect(string.hasAtLeastOneSymbol()) == false
                }
            }
        }
        
        describe("when convert to card mask number called") {
            it("should return correct card format string") {
                let cardNumber = "4242424242424242"
                let expectedString = "4242 4242 4242 4242"
                
                expect(cardNumber.asCardMaskNumber()) == expectedString
            }
        }
        
        describe("when convert to default card number called") {
            it("should return correct card format string") {
                let cardNumber = "4242 4242 4242 4242"
                let expectedString = "4242424242424242"
                
                expect(cardNumber.asCardDefaultNumber()) == expectedString
            }
        }
    }
}
