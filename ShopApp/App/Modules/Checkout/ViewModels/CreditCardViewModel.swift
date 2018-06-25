//
//  CreditCardViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class CreditCardViewModel: BaseViewModel {
    var holderNameText = Variable<String>("")
    var cardNumberText = Variable<String>("")
    var monthExpirationText = Variable<String>("")
    var yearExpirationText = Variable<String>("")
    var securityCodeText = Variable<String>("")
    var holderNameErrorMessage = PublishSubject<String>()
    var cardNumberErrorMessage = PublishSubject<String>()
    var filledCard = PublishSubject<Card>()
    var card: Card?
    
    var isCardDataValid: Observable<Bool> {
        return Observable.combineLatest(holderNameText.asObservable(), cardNumberText.asObservable(), monthExpirationText.asObservable(), yearExpirationText.asObservable(), securityCodeText.asObservable()) { holderName, cardNumber, monthExpiration, yearExpiration, securityCode in
            return holderName.hasAtLeastOneSymbol() && cardNumber.isValidAsCardNumber() && monthExpiration.hasAtLeastOneSymbol() && yearExpiration.hasAtLeastOneSymbol() && securityCode.isValidAsCVV()
        }
    }
    var submitTapped: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            switch event {
            case .next:
                guard let strongSelf = self else {
                    return
                }
                strongSelf.validateData()
            default:
                break
            }
        }
    }
    
    func updateFields() {
        guard let card = card else {
            return
        }
        holderNameText.value = card.holderName
        cardNumberText.value = card.cardNumber.asCardMaskNumber()
        monthExpirationText.value = card.expireMonth
        yearExpirationText.value = card.expireYear
        securityCodeText.value = card.verificationCode
    }
    
    private func validateData() {
        if holderNameText.value.isValidAsHolderName() && cardNumberText.value.asCardDefaultNumber().luhnValid() {
            submitAction()
        } else {
            processErrors()
        }
    }
    
    private func submitAction() {
        filledCard.onNext(generateCreditCard())
    }
    
    private func processErrors() {
        if holderNameText.value.isValidAsHolderName() == false {
            holderNameErrorMessage.onNext("Error.InvalidHolderName".localizable)
        } else if cardNumberText.value.asCardDefaultNumber().luhnValid() == false {
            cardNumberErrorMessage.onNext("Error.InvalidCardNumber".localizable)
        }
    }
    
    private func generateCreditCard() -> Card {
        let names = holderNameText.value.split(separator: " ", maxSplits: 1)
        let firstName = String(describing: names.first!)
        let lastName = String(describing: names.last!)
        let cardNumber = cardNumberText.value.asCardDefaultNumber()
        let expireMonth = monthExpirationText.value
        let expireYear = yearExpirationText.value
        let verificationCode = securityCodeText.value
        
        return Card(firstName: firstName, lastName: lastName, cardNumber: cardNumber, expireMonth: expireMonth, expireYear: expireYear, verificationCode: verificationCode)
    }
}
