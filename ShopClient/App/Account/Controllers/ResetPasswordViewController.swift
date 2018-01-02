//
//  ResetPasswordViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ResetPasswordViewController: BaseViewController<ResetPasswordViewModel> {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailTextFieldView: InputTextFieldView!
    @IBOutlet weak var forgotPasswordButton: BlackButton!
    
    override func viewDidLoad() {
        viewModel = ResetPasswordViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }

    private func setupViews() {
        addCloseButton()
        title = NSLocalizedString("ControllerTitle.ForgorPassword", comment: String())
        titleLabel.text = NSLocalizedString("Label.ForgotPassword.PasswordTitle", comment: String())
        descriptionLabel.text = NSLocalizedString("Label.ForgotPassword.PasswordDescription", comment: String())
        emailTextFieldView.placeholder = NSLocalizedString("Placeholder.Email", comment: String()).uppercased()
        forgotPasswordButton.setTitle(NSLocalizedString("Button.Submit", comment: String()).uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        emailTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        viewModel.emailErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.emailTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        forgotPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        forgotPasswordButton.rx.tap
            .bind(to: viewModel.resetPasswordPressed)
            .disposed(by: disposeBag)
        
        viewModel.resetPasswordButtonEnabled
            .subscribe(onNext: { [weak self] enabled in
                self?.forgotPasswordButton.isEnabled = enabled
            })
            .disposed(by: disposeBag)
        
        viewModel.resetPasswordSuccess.asObservable()
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
