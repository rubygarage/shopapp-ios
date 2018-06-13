//
//  ShopAppPaymentsRepositorySpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ShopAppPaymentRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppPaymentRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppPaymentRepository(api: apiMock)
        }
        
        describe("when checkout should be create") {
            var cartProducts: [CartProduct]!
            
            beforeEach {
                cartProducts = []
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.createCheckout(cartProducts: cartProducts) { (result, error) in
                        expect(apiMock.isCreateCheckoutStarted) == true
                        
                        expect(apiMock.cartProducts) === cartProducts
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.createCheckout(cartProducts: cartProducts) { (result, error) in
                        expect(apiMock.isCreateCheckoutStarted) == true
                        
                        expect(apiMock.cartProducts) === cartProducts
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when checkout should be get") {
            var checkoutId: String!
            
            beforeEach {
                checkoutId = ""
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getCheckout(checkoutId: checkoutId) { (result, error) in
                        expect(apiMock.isGetCheckoutStarted) == true
                        
                        expect(apiMock.checkoutId) == checkoutId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getCheckout(checkoutId: checkoutId) { (result, error) in
                        expect(apiMock.isGetCheckoutStarted) == true
                        
                        expect(apiMock.checkoutId) == checkoutId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when shipping address should be update") {
            var checkoutId: String!
            var address: Address!
            
            beforeEach {
                checkoutId = ""
                address = Address()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.setShippingAddress(checkoutId: checkoutId, address: address) { (result, error) in
                        expect(apiMock.isUpdateShippingAddressStarted) == true
                        
                        expect(apiMock.checkoutId) == checkoutId
                        expect(apiMock.address) === address
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.setShippingAddress(checkoutId: checkoutId, address: address) { (result, error) in
                        expect(apiMock.isUpdateShippingAddressStarted) == true
                        
                        expect(apiMock.checkoutId) == checkoutId
                        expect(apiMock.address) === address
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when shipping rates should be get") {
            var checkoutId: String!
            
            beforeEach {
                checkoutId = ""
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getShippingRates(checkoutId: checkoutId) { (result, error) in
                        expect(apiMock.isGetShippingRatesStarted) == true
                        
                        expect(apiMock.checkoutId) == checkoutId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getShippingRates(checkoutId: checkoutId) { (result, error) in
                        expect(apiMock.isGetShippingRatesStarted) == true
                        
                        expect(apiMock.checkoutId) == checkoutId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when checkout should be update") {
            var shippingRate: ShippingRate!
            var checkoutId: String!
            
            beforeEach {
                shippingRate = ShippingRate()
                checkoutId = ""
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.setShippingRate(checkoutId: checkoutId, shippingRate: shippingRate) { (result, error) in
                        expect(apiMock.isUpdateCheckoutStarted) == true
                        
                        expect(apiMock.shippingRate) === shippingRate
                        expect(apiMock.checkoutId) == checkoutId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.setShippingRate(checkoutId: checkoutId, shippingRate: shippingRate) { (result, error) in
                        expect(apiMock.isUpdateCheckoutStarted) == true
                        
                        expect(apiMock.shippingRate) === shippingRate
                        expect(apiMock.checkoutId) == checkoutId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when user should pay") {
            var card: CreditCard!
            var checkout: Checkout!
            var address: Address!
            var email: String!
            
            beforeEach {
                card = CreditCard()
                checkout = Checkout()
                address = Address()
                email = "user@mail.com"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.completeCheckout(checkout: checkout, email: email, address: address, card: card) { (result, error) in
                        expect(apiMock.isPayStarted) == true
                        
                        expect(apiMock.card) === card
                        expect(apiMock.checkout) === checkout
                        expect(apiMock.billingAddress) === address
                        expect(apiMock.email) == email
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.completeCheckout(checkout: checkout, email: email, address: address, card: card) { (result, error) in
                        expect(apiMock.isPayStarted) == true
                        
                        expect(apiMock.card) === card
                        expect(apiMock.checkout) === checkout
                        expect(apiMock.billingAddress) === address
                        expect(apiMock.email) == email
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when apple pay should be setup") {
            var checkout: Checkout!
            var email: String!
            
            beforeEach {
                checkout = Checkout()
                email = "user@mail.com"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.setupApplePay(checkout: checkout, email: email) { (result, error) in
                        expect(apiMock.isSetupApplePayStarted) == true
                        
                        expect(apiMock.checkout) === checkout
                        expect(apiMock.email) == email
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.setupApplePay(checkout: checkout, email: email) { (result, error) in
                        expect(apiMock.isSetupApplePayStarted) == true
                        
                        expect(apiMock.checkout) === checkout
                        expect(apiMock.email) == email
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
