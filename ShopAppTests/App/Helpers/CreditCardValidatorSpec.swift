//
//  CreditCardValidatorSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CreditCardValidatorSpec: QuickSpec {
    override func spec() {
        describe("when card type name used") {
            context("if card number is amex") {
                it("needs to return correct type name") {
                    expect(CreditCardValidator.cardTypeName(for: "3400000")) == "Amex"
                    expect(CreditCardValidator.cardTypeName(for: "3700000")) == "Amex"
                    expect(CreditCardValidator.cardTypeName(for: "3499999")) == "Amex"
                    expect(CreditCardValidator.cardTypeName(for: "3799999")) == "Amex"
                    
                    expect(CreditCardValidator.cardTypeName(for: "34000000")) == "Amex"
                    expect(CreditCardValidator.cardTypeName(for: "37000000")) == "Amex"
                    expect(CreditCardValidator.cardTypeName(for: "34999999")) == "Amex"
                    expect(CreditCardValidator.cardTypeName(for: "37999999")) == "Amex"
                }
            }
            
            context("if card number is visa") {
                it("needs to return correct type name") {
                    expect(CreditCardValidator.cardTypeName(for: "4")) == "Visa"
                    
                    expect(CreditCardValidator.cardTypeName(for: "40")) == "Visa"
                    expect(CreditCardValidator.cardTypeName(for: "49")) == "Visa"
                    
                    expect(CreditCardValidator.cardTypeName(for: "400")) == "Visa"
                    expect(CreditCardValidator.cardTypeName(for: "499")) == "Visa"
                }
            }
            
            context("if card number is mastercard") {
                it("needs to return correct type name") {
                    expect(CreditCardValidator.cardTypeName(for: "51")) == "MasterCard"
                    expect(CreditCardValidator.cardTypeName(for: "55")) == "MasterCard"
                    
                    expect(CreditCardValidator.cardTypeName(for: "510")) == "MasterCard"
                    expect(CreditCardValidator.cardTypeName(for: "559")) == "MasterCard"
                    
                    expect(CreditCardValidator.cardTypeName(for: "5100000000000000")) == "MasterCard"
                    expect(CreditCardValidator.cardTypeName(for: "5599999999999999")) == "MasterCard"
                }
            }
            
            context("if card number is diners club") {
                it("needs to return correct type name") {
                    expect(CreditCardValidator.cardTypeName(for: "3000000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3050000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3600000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3800000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3690000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3890000")) == "Diners Club"
                    
                    expect(CreditCardValidator.cardTypeName(for: "3009999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3059999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3609999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3809999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3699999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "3899999")) == "Diners Club"
                    
                    expect(CreditCardValidator.cardTypeName(for: "30000000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "30500000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "36000000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "38000000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "36900000")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "38900000")) == "Diners Club"
                    
                    expect(CreditCardValidator.cardTypeName(for: "30099999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "30599999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "36099999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "38099999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "36999999")) == "Diners Club"
                    expect(CreditCardValidator.cardTypeName(for: "38999999")) == "Diners Club"
                }
            }
            
            context("if card number is jcb") {
                it("needs to return correct type name") {
                    expect(CreditCardValidator.cardTypeName(for: "2131000")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "1800000")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "35000000")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "35999000")) == "JCB"
                    
                    expect(CreditCardValidator.cardTypeName(for: "2131999")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "1800999")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "35000999")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "35999999")) == "JCB"
                    
                    expect(CreditCardValidator.cardTypeName(for: "21310000")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "18000000")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "350000000")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "359990000")) == "JCB"
                    
                    expect(CreditCardValidator.cardTypeName(for: "21319999")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "18009999")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "350009999")) == "JCB"
                    expect(CreditCardValidator.cardTypeName(for: "359999999")) == "JCB"
                }
            }
            
            context("if card number is discover") {
                it("needs to return correct type name") {
                    expect(CreditCardValidator.cardTypeName(for: "6011000")) == "Discover"
                    expect(CreditCardValidator.cardTypeName(for: "6500000")) == "Discover"
                    expect(CreditCardValidator.cardTypeName(for: "6599000")) == "Discover"
                    
                    expect(CreditCardValidator.cardTypeName(for: "6011999")) == "Discover"
                    expect(CreditCardValidator.cardTypeName(for: "6500999")) == "Discover"
                    expect(CreditCardValidator.cardTypeName(for: "6599999")) == "Discover"
                    
                    expect(CreditCardValidator.cardTypeName(for: "60110000")) == "Discover"
                    expect(CreditCardValidator.cardTypeName(for: "65000000")) == "Discover"
                    expect(CreditCardValidator.cardTypeName(for: "65990000")) == "Discover"
                    
                    expect(CreditCardValidator.cardTypeName(for: "60119999")) == "Discover"
                    expect(CreditCardValidator.cardTypeName(for: "65009999")) == "Discover"
                    expect(CreditCardValidator.cardTypeName(for: "65999999")) == "Discover"
                }
            }
            
            context("if card number is invalid") {
                it("needs to return nil") {
                    expect(CreditCardValidator.cardTypeName(for: "")).to(beNil())
                }
            }
        }

        describe("when card image name used") {
            context("if card number is amex") {
                it("needs to return correct image name") {
                    expect(CreditCardValidator.cardImageName(for: "3400000")) == "card_type_amex"
                    expect(CreditCardValidator.cardImageName(for: "3700000")) == "card_type_amex"
                    expect(CreditCardValidator.cardImageName(for: "3499999")) == "card_type_amex"
                    expect(CreditCardValidator.cardImageName(for: "3799999")) == "card_type_amex"
                    
                    expect(CreditCardValidator.cardImageName(for: "34000000")) == "card_type_amex"
                    expect(CreditCardValidator.cardImageName(for: "37000000")) == "card_type_amex"
                    expect(CreditCardValidator.cardImageName(for: "34999999")) == "card_type_amex"
                    expect(CreditCardValidator.cardImageName(for: "37999999")) == "card_type_amex"
                }
            }
            
            context("if card number is visa") {
                it("needs to return correct image name") {
                    expect(CreditCardValidator.cardImageName(for: "4")) == "card_type_visa"
                    
                    expect(CreditCardValidator.cardImageName(for: "40")) == "card_type_visa"
                    expect(CreditCardValidator.cardImageName(for: "49")) == "card_type_visa"
                    
                    expect(CreditCardValidator.cardImageName(for: "400")) == "card_type_visa"
                    expect(CreditCardValidator.cardImageName(for: "499")) == "card_type_visa"
                }
            }
            
            context("if card number is mastercard") {
                it("needs to return correct image name") {
                    expect(CreditCardValidator.cardImageName(for: "51")) == "card_type_master_card"
                    expect(CreditCardValidator.cardImageName(for: "55")) == "card_type_master_card"
                    
                    expect(CreditCardValidator.cardImageName(for: "510")) == "card_type_master_card"
                    expect(CreditCardValidator.cardImageName(for: "559")) == "card_type_master_card"
                    
                    expect(CreditCardValidator.cardImageName(for: "5100000000000000")) == "card_type_master_card"
                    expect(CreditCardValidator.cardImageName(for: "5599999999999999")) == "card_type_master_card"
                }
            }
            
            context("if card number is diners club") {
                it("needs to return correct image name") {
                    expect(CreditCardValidator.cardImageName(for: "3000000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3050000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3600000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3800000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3690000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3890000")) == "card_type_dc_card"
                    
                    expect(CreditCardValidator.cardImageName(for: "3009999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3059999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3609999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3809999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3699999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "3899999")) == "card_type_dc_card"
                    
                    expect(CreditCardValidator.cardImageName(for: "30000000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "30500000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "36000000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "38000000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "36900000")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "38900000")) == "card_type_dc_card"
                    
                    expect(CreditCardValidator.cardImageName(for: "30099999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "30599999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "36099999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "38099999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "36999999")) == "card_type_dc_card"
                    expect(CreditCardValidator.cardImageName(for: "38999999")) == "card_type_dc_card"
                }
            }
            
            context("if card number is jcb") {
                it("needs to return correct image name") {
                    expect(CreditCardValidator.cardImageName(for: "2131000")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "1800000")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "35000000")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "35999000")) == "card_type_jcb_card"
                    
                    expect(CreditCardValidator.cardImageName(for: "2131999")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "1800999")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "35000999")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "35999999")) == "card_type_jcb_card"
                    
                    expect(CreditCardValidator.cardImageName(for: "21310000")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "18000000")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "350000000")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "359990000")) == "card_type_jcb_card"
                    
                    expect(CreditCardValidator.cardImageName(for: "21319999")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "18009999")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "350009999")) == "card_type_jcb_card"
                    expect(CreditCardValidator.cardImageName(for: "359999999")) == "card_type_jcb_card"
                }
            }
            
            context("if card number is discover") {
                it("needs to return correct image name") {
                    expect(CreditCardValidator.cardImageName(for: "6011000")) == "card_type_discover"
                    expect(CreditCardValidator.cardImageName(for: "6500000")) == "card_type_discover"
                    expect(CreditCardValidator.cardImageName(for: "6599000")) == "card_type_discover"
                    
                    expect(CreditCardValidator.cardImageName(for: "6011999")) == "card_type_discover"
                    expect(CreditCardValidator.cardImageName(for: "6500999")) == "card_type_discover"
                    expect(CreditCardValidator.cardImageName(for: "6599999")) == "card_type_discover"
                    
                    expect(CreditCardValidator.cardImageName(for: "60110000")) == "card_type_discover"
                    expect(CreditCardValidator.cardImageName(for: "65000000")) == "card_type_discover"
                    expect(CreditCardValidator.cardImageName(for: "65990000")) == "card_type_discover"
                    
                    expect(CreditCardValidator.cardImageName(for: "60119999")) == "card_type_discover"
                    expect(CreditCardValidator.cardImageName(for: "65009999")) == "card_type_discover"
                    expect(CreditCardValidator.cardImageName(for: "65999999")) == "card_type_discover"
                }
            }
            
            context("if card number is invalid") {
                it("needs to return nil") {
                    expect(CreditCardValidator.cardImageName(for: "")).to(beNil())
                }
            }
        }
    }
}
