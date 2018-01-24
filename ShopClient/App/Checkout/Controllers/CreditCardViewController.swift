//
//  CreditCardViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CreditCardViewController: BaseViewController<CreditCardViewModel> {
    @IBOutlet private weak var holderNameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var cardNumberTextFieldView: InputTextFieldView!
    @IBOutlet private weak var securityCodeTextFieldView: InputTextFieldView!
    @IBOutlet private weak var expirationDateLabel: UILabel!
    @IBOutlet private weak var monthExpirationView: MonthExpiryDatePicker!
    @IBOutlet private weak var yearExpirationView: YearExpiryDatePicker!
    @IBOutlet private weak var submitButton: BlackButton!
    
    var completion: CreditCardCompletion?
    
    override func viewDidLoad() {
        viewModel = CreditCardViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        title = "ControllerTitle.CreditCard".localizable
        holderNameTextFieldView.placeholder = "Placeholder.CardHolderName".localizable.required.uppercased()
        cardNumberTextFieldView.placeholder = "Placeholder.CardNumber".localizable.required.uppercased()
        securityCodeTextFieldView.placeholder = "Placeholder.CVV".localizable.required.uppercased()
        expirationDateLabel.text = "Label.ExpirationDate".localizable.required.uppercased()
        submitButton.setTitle("Button.PayWithThisCard".localizable.uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        viewModel.completion = completion
        
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
