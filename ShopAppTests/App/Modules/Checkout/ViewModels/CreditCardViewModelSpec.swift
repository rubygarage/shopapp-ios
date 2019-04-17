//
//  CreditCardViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CreditCardViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: CreditCardViewModel!
        
        beforeEach {
            viewModel = CreditCardViewModel()
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
        }
        
        describe("when is card valid called") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if card not valid") {
                it("should return false") {
                    viewModel.isCardDataValid
                        .subscribe(onNext: { result in
                            expect(result) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if card valid") {
                it("should return true") {
                    viewModel.holderNameText.value = "Holder name"
                    viewModel.cardNumberText.value = "4111 1111 1111 1111"
                    viewModel.monthExpirationText.value = "12"
                    viewModel.yearExpirationText.value = "20"
                    viewModel.securityCodeText.value = "555"
                    
                    viewModel.isCardDataValid
                        .subscribe(onNext: { result in
                            expect(result) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
        
        describe("when 'submitTapped' called") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if data not valid") {
                context("if holder name text not valid") {
                    it("should show holder name error message") {
                        viewModel.holderNameText.value = ""
                        viewModel.cardNumberText.value = "4111 1111 1111 1111"
                        
                        viewModel.holderNameErrorMessage
                            .subscribe(onNext: { message in
                                expect(message) == "Error.InvalidHolderName".localizable
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.submitTapped.onNext(())
                    }
                }
                
                context("if card number text not valid") {
                    it("should show card number error message") {
                        viewModel.holderNameText.value = "Holder name"
                        viewModel.cardNumberText.value = "123"
                        
                        viewModel.cardNumberErrorMessage
                            .subscribe(onNext: { message in
                                expect(message) == "Error.InvalidCardNumber".localizable
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.submitTapped.onNext(())
                    }
                }
            }
            
            context("if data valid") {
                it("should return card") {
                    let firstName = "Holder"
                    let lastName = "Name"
                    let cardNumber = "4111111111111111"
                    let expireMonth = "12"
                    let expireYear = "20"
                    let verificationCode = "555"
                    
                    viewModel.holderNameText.value = firstName + " " + lastName
                    viewModel.cardNumberText.value = cardNumber
                    viewModel.monthExpirationText.value = expireMonth
                    viewModel.yearExpirationText.value = expireYear
                    viewModel.securityCodeText.value = verificationCode
                    
                    viewModel.filledCard
                        .subscribe(onNext: { card in
                            expect(card.firstName) == firstName
                            expect(card.lastName) == lastName
                            expect(card.cardNumber) == cardNumber
                            expect(card.expireMonth) == expireMonth
                            expect(card.expireYear) == expireYear
                            expect(card.verificationCode) == verificationCode
                        })
                    .disposed(by: disposeBag)
                    
                    viewModel.submitTapped.onNext(())
                }
            }
        }
        
        describe("when update fields called") {
            it("should update fields") {
                let card = CreditCard()
                card.firstName = "Holder"
                card.lastName = "Name"
                card.expireMonth = "12"
                card.expireYear = "20"
                card.verificationCode = "555"
                viewModel.card = card
                
                viewModel.updateFields()
                
                expect(viewModel.holderNameText.value) == card.firstName + " " + card.lastName
                expect(viewModel.cardNumberText.value) == card.cardNumber.asCardMaskNumber()
                expect(viewModel.monthExpirationText.value) == card.expireMonth
                expect(viewModel.yearExpirationText.value) == card.expireYear
                expect(viewModel.securityCodeText.value) == card.verificationCode
            }
        }
    }
}
