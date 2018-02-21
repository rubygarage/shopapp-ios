//
//  CreditCardViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol CreditCardControllerDelegate: class {
    func viewController(_ controller: CreditCardViewController, didFilled card: CreditCard)
}

class CreditCardViewController: BaseViewController<CreditCardViewModel>, InputTextFieldViewDelegate {
    @IBOutlet private weak var holderNameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var cardNumberTextFieldView: InputTextFieldView!
    @IBOutlet private weak var securityCodeTextFieldView: InputTextFieldView!
    @IBOutlet private weak var expirationDateLabel: UILabel!
    @IBOutlet private weak var monthExpirationView: MonthExpiryDatePicker!
    @IBOutlet private weak var yearExpirationView: YearExpiryDatePicker!
    @IBOutlet private weak var submitButton: BlackButton!
    @IBOutlet private weak var acceptedCardTypesLabel: UILabel!
    @IBOutlet private weak var cardTypeImageView: UIImageView!
    
    var card: CreditCard?
    
    weak var delegate: CreditCardControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        populateViewsIfNeeded()
    }
    
    private func setupViews() {
        title = "ControllerTitle.CreditCard".localizable
        holderNameTextFieldView.placeholder = "Placeholder.CardHolderName".localizable.required.uppercased()
        cardNumberTextFieldView.placeholder = "Placeholder.CardNumber".localizable.required.uppercased()
        cardNumberTextFieldView.delegate = self
        securityCodeTextFieldView.placeholder = "Placeholder.CVV".localizable.required.uppercased()
        expirationDateLabel.text = "Label.ExpirationDate".localizable.required.uppercased()
        submitButton.setTitle("Button.PayWithThisCard".localizable.uppercased(), for: .normal)
        acceptedCardTypesLabel.text = "Label.WeAccept".localizable.uppercased()
    }
    
    private func setupViewModel() {
        viewModel.card = card
        
        holderNameTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.holderNameText)
            .disposed(by: disposeBag)
        
        cardNumberTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.cardNumberText)
            .disposed(by: disposeBag)
        
        monthExpirationView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.monthExpirationText)
            .disposed(by: disposeBag)
        
        yearExpirationView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.yearExpirationText)
            .disposed(by: disposeBag)
        
        securityCodeTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.securityCodeText)
            .disposed(by: disposeBag)
        
        viewModel.isCardDataValid
            .subscribe(onNext: { [weak self] (isCardDataValid) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.submitButton.isEnabled = isCardDataValid
            })
            .disposed(by: disposeBag)
        
        viewModel.holderNameErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.holderNameTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        viewModel.cardNumberErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.cardNumberTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        viewModel.filledCard
            .subscribe(onNext: { [weak self] card in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.viewController(strongSelf, didFilled: card)
            })
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitTapped)
            .disposed(by: disposeBag)
    }
    
    private func populateViewsIfNeeded() {
        guard let card = card else {
            return
        }
        holderNameTextFieldView.text = card.holderName
        cardNumberTextFieldView.text = card.cardNumber.asCardMaskNumber()
        securityCodeTextFieldView.text = card.verificationCode
        monthExpirationView.text = card.expireMonth
        yearExpirationView.text = card.expireYear
        populateCardTypeImage(with: card.cardNumber)
        viewModel.updateFields()
    }
    
    private func populateCardTypeImage(with cardNumber: String) {
        guard let imageName = CreditCardValidator.cardImageName(for: cardNumber.asCardDefaultNumber()) else {
            cardTypeImageView.image = nil
            return
        }
        cardTypeImageView.image = UIImage(named: imageName)
    }
    
    // MARK: - InputTextFieldViewDelegate
    
    func textFieldView(_ view: InputTextFieldView, didUpdate text: String) {
        populateCardTypeImage(with: text)
    }
}
