//
//  CreditCardViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CreditCardViewController: BaseViewController<CreditCardViewModel> {
    @IBOutlet weak var holderNameTextFieldView: InputTextFieldView!
    @IBOutlet weak var cardNumberTextFieldView: InputTextFieldView!
    @IBOutlet weak var securityCodeTextFieldView: InputTextFieldView!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var submitButton: BlackButton!
    
    override func viewDidLoad() {
        viewModel = CreditCardViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.CreditCard", comment: String())
        holderNameTextFieldView.placeholder = NSLocalizedString("Placeholder.CardHolderName", comment: String()).uppercased()
        cardNumberTextFieldView.placeholder = NSLocalizedString("Placeholder.CardNumber", comment: String()).uppercased()
        securityCodeTextFieldView.placeholder = NSLocalizedString("Placeholder.CVV", comment: String()).uppercased()
        expirationDateLabel.text = NSLocalizedString("Label.ExpirationDate", comment: String()).uppercased()
        submitButton.setTitle(NSLocalizedString("Button.Submit", comment: String()).uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        holderNameTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.holderNameText)
            .disposed(by: disposeBag)
        
        cardNumberTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.cardNumberText)
            .disposed(by: disposeBag)
        
        securityCodeTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.securityCodeText)
            .disposed(by: disposeBag)
        
        viewModel.isCardDataValid
            .subscribe(onNext: { [weak self] (isCardDataValid) in
                self?.submitButton.isEnabled = isCardDataValid
            })
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitTapped)
            .disposed(by: disposeBag)
        
        viewModel.holderNameErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.holderNameTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        viewModel.cardNumberErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.cardNumberTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
    }
}
