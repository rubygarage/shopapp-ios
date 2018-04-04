//
//  CheckoutUseCaseSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 4/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutUseCaseSpec: QuickSpec {
    override func spec() {
        var useCase: CheckoutUseCase!
        var repositoryMock: PaymentsRepositoryMock!
        
        beforeEach {
            repositoryMock = PaymentsRepositoryMock()
            useCase = CheckoutUseCase(repository: repositoryMock)
        }
        
        describe("when checkout should be get") {
            var checkoutId: String!
            
            beforeEach {
                checkoutId = "id"
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.getCheckout(with: checkoutId) { (result, error) in
                        expect(repositoryMock.isGetCheckoutStarted) == true
                        
                        expect(repositoryMock.checkoutId) == checkoutId
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.getCheckout(with: checkoutId) { (result, error) in
                        expect(repositoryMock.isGetCheckoutStarted) == true
                        
                        expect(repositoryMock.checkoutId) == checkoutId
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when checkout shipping address should be update") {
            var checkoutId: String!
            var address: Address!
            
            beforeEach {
                checkoutId = "id"
                address = Address()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.updateCheckoutShippingAddress(with: checkoutId, address: address) { (result, error) in
                        expect(repositoryMock.isUpdateShippingAddressStarted) == true
                        
                        expect(repositoryMock.checkoutId) == checkoutId
                        expect(repositoryMock.address) === address
                        
                        expect(result) == true
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.updateCheckoutShippingAddress(with: checkoutId, address: address) { (result, error) in
                        expect(repositoryMock.isUpdateShippingAddressStarted) == true
                        
                        expect(repositoryMock.checkoutId) == checkoutId
                        expect(repositoryMock.address) === address
                        
                        expect(result) == false
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when checkout should be create") {
            var cartProducts: [CartProduct]!
            
            beforeEach {
                cartProducts = []
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.createCheckout(cartProducts: cartProducts) { (result, error) in
                        expect(repositoryMock.isCreateCheckoutStarted) == true
                        
                        expect(repositoryMock.cartProducts) === cartProducts
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.createCheckout(cartProducts: cartProducts) { (result, error) in
                        expect(repositoryMock.isCreateCheckoutStarted) == true
                        
                        expect(repositoryMock.cartProducts) === cartProducts
                        
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
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.pay(with: card, checkout: checkout, billingAddress: billingAddress, customerEmail: customerEmail) { (result, error) in
                        expect(repositoryMock.isPayStarted) == true
                        
                        expect(repositoryMock.card) === card
                        expect(repositoryMock.checkout) === checkout
                        expect(repositoryMock.billingAddress) === billingAddress
                        expect(repositoryMock.customerEmail) == customerEmail
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.pay(with: card, checkout: checkout, billingAddress: billingAddress, customerEmail: customerEmail) { (result, error) in
                        expect(repositoryMock.isPayStarted) == true
                        
                        expect(repositoryMock.card) === card
                        expect(repositoryMock.checkout) === checkout
                        expect(repositoryMock.billingAddress) === billingAddress
                        expect(repositoryMock.customerEmail) == customerEmail
                        
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
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.setupApplePay(with: checkout, customerEmail: customerEmail) { (result, error) in
                        expect(repositoryMock.isSetupApplePayStarted) == true
                        
                        expect(repositoryMock.checkout) === checkout
                        expect(repositoryMock.customerEmail) == customerEmail
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.setupApplePay(with: checkout, customerEmail: customerEmail) { (result, error) in
                        expect(repositoryMock.isSetupApplePayStarted) == true
                        
                        expect(repositoryMock.checkout) === checkout
                        expect(repositoryMock.customerEmail) == customerEmail
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
        
        describe("when shipping rate should be update") {
            var checkoutId: String!
            var rate: ShippingRate!
            
            beforeEach {
                checkoutId = "id"
                rate = ShippingRate()
            }
            
            context("if callback has result") {
                it("needs to handle result") {
                    repositoryMock.isNeedToReturnError = false
                    
                    useCase.updateShippingRate(with: checkoutId, rate: rate) { (result, error) in
                        expect(repositoryMock.isUpdateCheckoutStarted) == true
                        
                        expect(repositoryMock.checkoutId) == checkoutId
                        expect(repositoryMock.rate) === rate
                        
                        expect(result).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
            
            context("if callback has error") {
                it("needs to handle error") {
                    repositoryMock.isNeedToReturnError = true
                    
                    useCase.updateShippingRate(with: checkoutId, rate: rate) { (result, error) in
                        expect(repositoryMock.isUpdateCheckoutStarted) == true
                        
                        expect(repositoryMock.checkoutId) == checkoutId
                        expect(repositoryMock.rate) === rate
                        
                        expect(result).to(beNil())
                        expect(error).toNot(beNil())
                    }
                }
            }
        }
    }
}
