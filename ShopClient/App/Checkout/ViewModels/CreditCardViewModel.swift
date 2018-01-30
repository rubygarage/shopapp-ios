//
//  CreditCardViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

typealias CreditCardCompletion = (_ card: CreditCard) -> Void

class CreditCardViewModel: BaseViewModel {
    var holderNameText = Variable<String>("")
    var cardNumberText = Variable<String>("")
    var monthExpirationText = Variable<String>("")
    var yearExpirationText = Variable<String>("")
    var securityCodeText = Variable<String>("")
    var holderNameErrorMessage = PublishSubject<String>()
    var cardNumberErrorMessage = PublishSubject<String>()
    var card: CreditCard?
    var completion: CreditCardCompletion?
        
    var isCardDataValid: Observable<Bool> {
        return Observable.combineLatest(holderNameText.asObservable(), cardNumberText.asObservable(), monthExpirationText.asObservable(), yearExpirationText.asObservable(), securityCodeText.asObservable()) { holderName, cardNumber, monthExpiration, yearExpiration, securityCode in
            return holderName.hasAtLeastOneSymbol() && cardNumber.isValidAsCardNumber() && monthExpiration.hasAtLeastOneSymbol() && yearExpiration.hasAtLeastOneSymbol() && securityCode.isValidAsCVV()
        }
    }
    var submitTapped: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.validateData()
        }
    }
    
    func updateFields() {
        guard let card = card else {
            return
        }
        holderNameText.value = card.holderName
        cardNumberText.value = card.cardNumber
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
        completion?(generateCreditCard())
    }
    
    private func processErrors() {
        if holderNameText.value.isValidAsHolderName() == false {
            holderNameErrorMessage.onNext("Error.InvalidHolderName".localizable)
        } else if cardNumberText.value.asCardDefaultNumber().luhnValid() == false {
            cardNumberErrorMessage.onNext("Error.InvalidCardNumber".localizable)
        }
    }
    
    private func generateCreditCard() -> CreditCard {
        let card = CreditCard()
        let names = holderNameText.value.split(separator: " ", maxSplits: 1)
        card.firstName = String(describing: names.first!)
        card.lastName = String(describing: names.last!)
        card.cardNumber = cardNumberText.value.asCardDefaultNumber()
        card.expireMonth = monthExpirationText.value.asShortMonth()
        card.expireYear = yearExpirationText.value
        card.verificationCode = securityCodeText.value
        
        return card
    }
}

internal extension String {
    func asShortMonth() -> String {
        return String(format: "%01d", Int(self)!)
    }
}
