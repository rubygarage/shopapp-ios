//
//  CreditCardViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CreditCardViewModelMock: CreditCardViewModel {
    var submitDidCalled = false
    
    override var submitTapped: AnyObserver<Void> {
        return AnyObserver { [weak self] event in
            guard let strongSelf = self else {
                return
            }
            strongSelf.submitDidCalled = true
        }
    }
    
    func setDataValid(isValid: Bool) {
        holderNameText.value = isValid ? "Holder name" : ""
        cardNumberText.value = isValid ? "4111111111111111" : ""
        monthExpirationText.value = isValid ? "12" : ""
        yearExpirationText.value = isValid ? "20" : ""
        securityCodeText.value = isValid ? "555" : ""
    }
    
    func generateHolderNameError(_ message: String) {
        holderNameErrorMessage.onNext(message)
    }
    
    func generateCardNumberError(_ message: String) {
        cardNumberErrorMessage.onNext(message)
    }
    
    func generateFilledCard(_ card: CreditCard) {
        filledCard.onNext(card)
    }
}
