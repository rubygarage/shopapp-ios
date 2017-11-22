//
//  CardValidationView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import MFCard

protocol CardValidationViewProtocol {
    func didCardFilled(with card: CreditCard?, errorMessage: String?)
}

class CardValidationView: NSObject, MFCardDelegate {
    var delegate: (UIViewController & CardValidationViewProtocol)?
    
    init(delegate: (UIViewController & CardValidationViewProtocol)?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - public
    public func show() {
        if let viewController = self.delegate {
            var cardView : MFCardView
            cardView  = MFCardView(withViewController: viewController)
            cardView.delegate = self
            cardView.autoDismiss = true
            cardView.showCard()
        }
    }
    
    // MARK: - private
    private func validate(card: Card) {
        let errorMessage = CardValidator.validate(card: card)
        let creditCard = errorMessage == nil ? CreditCard(with: card) : nil
        delegate?.didCardFilled(with: creditCard, errorMessage: errorMessage)
    }
    
    // MARK: - MFCardDelegate
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        if let errorMessage = error {
            delegate?.didCardFilled(with: nil, errorMessage: errorMessage)
        } else if let creditCard = card {
            validate(card: creditCard)
        }
    }
    
    func cardTypeDidIdentify(_ cardType: String) {
        // required method
    }
}
