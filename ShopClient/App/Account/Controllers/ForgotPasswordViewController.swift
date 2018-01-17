//
//  ForgotPasswordViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/2/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController<ForgotPasswordViewModel> {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var emailTextFieldView: InputTextFieldView!
    @IBOutlet private weak var forgotPasswordButton: BlackButton!
    @IBOutlet private weak var linkView: UIView!
    
    private var linkViewController: LinkViewController!
    
    override func viewDidLoad() {
        viewModel = ForgotPasswordViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let linkViewController = segue.destination as? LinkViewController {
            self.linkViewController = linkViewController
        }
    }

    private func setupViews() {
        addCloseButton()
        title = "ControllerTitle.ForgotPassword".localizable
        titleLabel.text = "Label.ForgotPassword.PasswordTitle".localizable
        descriptionLabel.text = "Label.ForgotPassword.PasswordDescription".localizable
        emailTextFieldView.placeholder = "Placeholder.Email".localizable.uppercased()
        forgotPasswordButton.setTitle("Button.Submit".localizable.uppercased(), for: .normal)
        
        emailTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: linkViewController.emailText)
            .disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        emailTextFieldView.textField.rx.text.map({ $0 ?? "" })
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
                self?.linkView.isHidden = !success
            })
            .disposed(by: disposeBag)
    }
}
