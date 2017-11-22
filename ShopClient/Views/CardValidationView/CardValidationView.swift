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
    func didCardFilled(with card: Card?, errorString: String?)
}

class CardValidationView: NSObject, MFCardDelegate {
    var delegate: (UIViewController & CardValidationViewProtocol)?
    
    init(delegate: (UIViewController & CardValidationViewProtocol)?) {
        super.init()
        
        self.delegate = delegate
    }
    
    public func show() {
        if let viewController = self.delegate {
            var cardView : MFCardView
            cardView  = MFCardView(withViewController: viewController)
            cardView.delegate = self
            cardView.autoDismiss = true
            cardView.showCard()
        }
    }
    
    // MARK: - MFCardDelegate
    func cardDoneButtonClicked(_ card: Card?, error: String?) {
        delegate?.didCardFilled(with: card, errorString: error)
    }
    
    func cardTypeDidIdentify(_ cardType: String) {
        print()
    }
}
