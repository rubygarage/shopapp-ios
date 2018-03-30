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

class ShopAppPaymentsRepositorySpec: QuickSpec {
    override func spec() {
        var repository: ShopAppPaymentsRepository!
        var apiMock: APIMock!
        
        beforeEach {
            apiMock = APIMock()
            repository = ShopAppPaymentsRepository(api: apiMock)
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
                    
                    repository.getCheckout(with: checkoutId) { (result, error) in
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
                    
                    repository.getCheckout(with: checkoutId) { (result, error) in
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
                    
                    repository.updateShippingAddress(with: checkoutId, address: address) { (result, error) in
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
                    
                    repository.updateShippingAddress(with: checkoutId, address: address) { (result, error) in
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
                    
                    repository.getShippingRates(with: checkoutId) { (result, error) in
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
                    
                    repository.getShippingRates(with: checkoutId) { (result, error) in
                        expect(apiMock.isGetShippingRatesStarted) == true
                        
                        expect(apiMock.checkoutId) == checkoutId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when checkout should be update") {
            var rate: ShippingRate!
            var checkoutId: String!
            
            beforeEach {
                rate = ShippingRate()
                checkoutId = ""
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.updateCheckout(with: rate, checkoutId: checkoutId) { (result, error) in
                        expect(apiMock.isUpdateCheckoutStarted) == true
                        
                        expect(apiMock.rate) === rate
                        expect(apiMock.checkoutId) == checkoutId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.updateCheckout(with: rate, checkoutId: checkoutId) { (result, error) in
                        expect(apiMock.isUpdateCheckoutStarted) == true
                        
                        expect(apiMock.rate) === rate
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
            var billingAddress: Address!
            var customerEmail: String!
            
            beforeEach {
                card = CreditCard()
                checkout = Checkout()
                billingAddress = Address()
                customerEmail = "user@mail.com"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.pay(with: card, checkout: checkout, billingAddress: billingAddress, customerEmail: customerEmail) { (result, error) in
                        expect(apiMock.isPayStarted) == true
                        
                        expect(apiMock.card) === card
                        expect(apiMock.checkout) === checkout
                        expect(apiMock.billingAddress) === billingAddress
                        expect(apiMock.customerEmail) == customerEmail
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.pay(with: card, checkout: checkout, billingAddress: billingAddress, customerEmail: customerEmail) { (result, error) in
                        expect(apiMock.isPayStarted) == true
                        
                        expect(apiMock.card) === card
                        expect(apiMock.checkout) === checkout
                        expect(apiMock.billingAddress) === billingAddress
                        expect(apiMock.customerEmail) == customerEmail
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when apple pay should be setup") {
            var checkout: Checkout!
            var customerEmail: String!
            
            beforeEach {
                checkout = Checkout()
                customerEmail = "user@mail.com"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.setupApplePay(with: checkout, customerEmail: customerEmail) { (result, error) in
                        expect(apiMock.isSetupApplePayStarted) == true
                        
                        expect(apiMock.checkout) === checkout
                        expect(apiMock.customerEmail) == customerEmail
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.setupApplePay(with: checkout, customerEmail: customerEmail) { (result, error) in
                        expect(apiMock.isSetupApplePayStarted) == true
                        
                        expect(apiMock.checkout) === checkout
                        expect(apiMock.customerEmail) == customerEmail
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when countries should be get") {
            context("if callback has result") {
                it("needs to handle result") {
                    apiMock.isNeedToReturnError = false
                    
                    repository.getCountries() { (result, error) in
                        expect(apiMock.isGetCountriesStarted) == true
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    apiMock.isNeedToReturnError = true
                    
                    repository.getCountries() { (result, error) in
                        expect(apiMock.isGetCountriesStarted) == true
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
