//
//  CreditCardViewControllerSpec.swift
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

class CreditCardViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CreditCardViewController!
        var viewModelMock: CreditCardViewModelMock!
        var holderNameTextFieldView: InputTextFieldView!
        var cardNumberTextFieldView: InputTextFieldView!
        var securityCodeTextFieldView: InputTextFieldView!
        var expirationDateLabel: UILabel!
        var monthExpirationView: MonthExpiryDatePicker!
        var yearExpirationView: YearExpiryDatePicker!
        var submitButton: BlackButton!
        var acceptedCardTypesLabel: UILabel!
        var cardTypeImageView: UIImageView!
        var card: CreditCard!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.checkout, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.creditCard) as? CreditCardViewController
            
            viewModelMock = CreditCardViewModelMock()
            viewController.viewModel = viewModelMock
            
            card = CreditCard()
            card.firstName = "Holder"
            card.lastName = "Name"
            card.cardNumber = "4111 1111 1111 1111"
            card.verificationCode = "555"
            card.expireMonth = "12"
            card.expireYear = "20"
            viewController.card = card
            
            holderNameTextFieldView = self.findView(withAccessibilityLabel: "holderNameTextFieldView", in: viewController.view) as? InputTextFieldView
            cardNumberTextFieldView = self.findView(withAccessibilityLabel: "cardNumberTextFieldView", in: viewController.view) as? InputTextFieldView
            securityCodeTextFieldView = self.findView(withAccessibilityLabel: "securityCodeTextFieldView", in: viewController.view) as? InputTextFieldView
            expirationDateLabel = self.findView(withAccessibilityLabel: "expirationDateLabel", in: viewController.view) as? UILabel
            monthExpirationView = self.findView(withAccessibilityLabel: "monthExpirationView", in: viewController.view) as? MonthExpiryDatePicker
            yearExpirationView = self.findView(withAccessibilityLabel: "yearExpirationView", in: viewController.view) as? YearExpiryDatePicker
            submitButton = self.findView(withAccessibilityLabel: "submitButton", in: viewController.view) as? BlackButton
            acceptedCardTypesLabel = self.findView(withAccessibilityLabel: "acceptedCardTypesLabel", in: viewController.view) as? UILabel
            cardTypeImageView = self.findView(withAccessibilityLabel: "cardTypeImageView", in: viewController.view) as? UIImageView
        }
        
        describe("when view loaded") {
            it("should have a correct title") {
                expect(viewController.title) == "ControllerTitle.CreditCard".localizable
            }
            
            it("should have a correct holder name textview placeholder") {
                expect(holderNameTextFieldView.placeholder) == "Placeholder.CardHolderName".localizable.required.uppercased()
            }
            
            it("should have a correct card number textview placeholder") {
                expect(cardNumberTextFieldView.placeholder) == "Placeholder.CardNumber".localizable.required.uppercased()
            }
            
            it("should have a correct card number textview delegate") {
                expect(cardNumberTextFieldView.delegate) === viewController
            }
            
            it("should have a correct security code textview placeholder") {
                expect(securityCodeTextFieldView.placeholder) == "Placeholder.CVV".localizable.required.uppercased()
            }
            
            it("should have a correct expiration date label text") {
                expect(expirationDateLabel.text) == "Label.ExpirationDate".localizable.required.uppercased()
            }
            
            it("should have a correct submit button title") {
                expect(submitButton.title(for: .normal)) == "Button.PayWithThisCard".localizable.uppercased()
            }
            
            it("should have a correct accepted card types label text") {
                expect(acceptedCardTypesLabel.text) == "Label.WeAccept".localizable.uppercased()
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(CreditCardViewModel.self))
            }
            
            it("should pass correct properties to view model") {
                expect(viewController.viewModel.card) === viewController.card
            }
        }
        
        describe("when views populated") {
            it("should hav a correct holder name textfield view text") {
                expect(holderNameTextFieldView.text) == card.firstName + " " + card.lastName
            }
            
            it("should have a correct card number textfield view text") {
                expect(cardNumberTextFieldView.text) == card.cardNumber.asCardMaskNumber()
            }
            
            it("should have a correct security code textfield view text") {
                expect(securityCodeTextFieldView.text) == card.verificationCode
            }
            
            it("should have a correct month expiration view text") {
                expect(monthExpirationView.text) == card.expireMonth
            }
            
            it("should have a correct year expiration view text") {
                expect(yearExpirationView.text) == card.expireYear
            }
            
            it("should have a correct card type view image") {
                let imageName = CreditCardValidator.cardImageName(for: card.cardNumber.asCardDefaultNumber())
                expect(cardTypeImageView.image) == UIImage(named: imageName!)
            }
        }
        
        describe("when inputs changed text") {
            it("should have a correct holder name binding") {
                let text = "Holder name"
                holderNameTextFieldView.text = text
                holderNameTextFieldView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.holderNameText.value) == text
            }
            
            it("should have a correct card number binding") {
                let text = "4111 1111 1111 1111"
                cardNumberTextFieldView.text = text
                cardNumberTextFieldView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.cardNumberText.value) == text
            }
            
            it("should have a correct security code binding") {
                let text = "555"
                securityCodeTextFieldView.text = text
                securityCodeTextFieldView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.securityCodeText.value) == text
            }
            
            it("should have a corect month expiration view binding") {
                let text = "12"
                monthExpirationView.text = text
                monthExpirationView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.monthExpirationText.value) == text
            }
            
            it("should have a corect year expiration view binding") {
                let text = "20"
                yearExpirationView.text = text
                yearExpirationView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.yearExpirationText.value) == text
            }
        }
        
        describe("when is card valid called") {
            context("if data valid") {
                it("should enable submit button") {
                    viewModelMock.setDataValid(isValid: true)
                    
                    expect(submitButton.isEnabled) == true
                }
            }
            
            context("if data not valid") {
                it("should disable submit button") {
                    viewModelMock.setDataValid(isValid: false)
                    
                    expect(submitButton.isEnabled) == false
                }
            }
        }
        
        describe("when holder name error get") {
            it("should show error message") {
                let message = "Holder name error message"
                viewModelMock.generateHolderNameError(message)
                
                expect(holderNameTextFieldView.errorMessage) == message
            }
        }
        
        describe("when card number error get") {
            it("should show error message") {
                let message = "Card number error message"
                viewModelMock.generateCardNumberError(message)
                
                expect(cardNumberTextFieldView.errorMessage) == message
            }
        }
        
        describe("when filled card get") {
            it("should pass card to delegate") {
                let delegateMock = CreditCardControllerDelegateMock()
                viewController.delegate = delegateMock
                
                let card = CreditCard()
                viewModelMock.generateFilledCard(card)
                
                expect(delegateMock.controller) == viewController
                expect(delegateMock.card) === card
            }
        }
        
        describe("when submit did press") {
            it("should start validation") {
                submitButton.sendActions(for: .touchUpInside)
                
                expect(viewModelMock.submitDidCalled) == true
            }
        }
        
        describe("when card number textfield view changed text") {
            let inputTextFieldView = InputTextFieldView()
            
            context("if card number valid") {
                it("should set a correct image") {
                    viewController.textFieldView(inputTextFieldView, didUpdate: card.cardNumber)
                    
                    let imageName = CreditCardValidator.cardImageName(for: card.cardNumber.asCardDefaultNumber())
                    expect(cardTypeImageView.image) == UIImage(named: imageName!)
                }
            }
            
            context("if card number is nil") {
                it("should set nil") {
                    viewController.textFieldView(inputTextFieldView, didUpdate: "")
                    
                    expect(cardTypeImageView.image).to(beNil())
                }
            }
        }
    }
}
