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
    @IBOutlet weak var monthExpirationView: MonthExpiryDatePicker!
    @IBOutlet weak var yearExpirationView: YearExpiryDatePicker!
    @IBOutlet weak var submitButton: BlackButton!
    
    var billingAddres: Address!
    var completion: CreditCardPaymentCompletion?
    
    override func viewDidLoad() {
        viewModel = CreditCardViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        title = "ControllerTitle.CreditCard".localizable
        holderNameTextFieldView.placeholder = "Placeholder.CardHolderName".localizable.uppercased()
        cardNumberTextFieldView.placeholder = "Placeholder.CardNumber".localizable.uppercased()
        securityCodeTextFieldView.placeholder = "Placeholder.CVV".localizable.uppercased()
        expirationDateLabel.text = "Label.ExpirationDate".localizable.uppercased()
        submitButton.setTitle("Button.Submit".localizable.uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        viewModel.billingAddres = billingAddres
        viewModel.completion = completion
        
        holderNameTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.holderNameText)
            .disposed(by: disposeBag)
        
        cardNumberTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.cardNumberText)
            .disposed(by: disposeBag)
        
        monthExpirationView.dateTextField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.monthExpirationText)
            .disposed(by: disposeBag)
        
        yearExpirationView.dateTextField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.yearExpirationText)
            .disposed(by: disposeBag)
        
        securityCodeTextFieldView.textField.rx.text.map({ $0 ?? "" })
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
