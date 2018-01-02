//
//  CreditCardViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CreditCardViewModel: BaseViewModel {
    var holderNameText = Variable<String>("")
    var cardNumberText = Variable<String>("")
    var securityCodeText = Variable<String>("")
    var holderNameErrorMessage = PublishSubject<String>()
    var cardNumberErrorMessage = PublishSubject<String>()
    
    var isCardDataValid: Observable<Bool> {
        return Observable.combineLatest(holderNameText.asObservable(), cardNumberText.asObservable(), securityCodeText.asObservable()) { holderName, cardNumber, securityCode in
            return holderName.hasAtLeastOneSymbol() && cardNumber.isValidAsCardNumber() && securityCode.isValidAsCVV()
        }
    }
    
    var submitTapped: AnyObserver<()> {
        return AnyObserver { [weak self] event in
            self?.validateData()
        }
    }
    
    // MARK: - private
    private func validateData() {
        if holderNameText.value.isValidAsHolderName() && cardNumberText.value.luhnValid() {
            submitAction()
        } else {
            processErrors()
        }
    }
    
    private func submitAction() {
        // TODO:
    }
    
    private func processErrors() {
        if holderNameText.value.isValidAsHolderName() == false {
            holderNameErrorMessage.onNext(NSLocalizedString("Error.InvalidHolderName", comment: String()))
        } else if cardNumberText.value.luhnValid() == false {
            cardNumberErrorMessage.onNext(NSLocalizedString("Error.InvalidCardNumber", comment: String()))
        }
    }
}
