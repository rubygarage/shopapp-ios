//
//  ChangePasswordViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController<ChangePasswordViewModel> {
    @IBOutlet private weak var newPasswordTextFieldView: InputTextFieldView!
    @IBOutlet private weak var confirmPasswordTextFieldView: InputTextFieldView!
    @IBOutlet private weak var updateButton: BlackButton!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = ChangePasswordViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addCloseButton()
        title = "ControllerTitle.SetNewPassword".localizable
        newPasswordTextFieldView.placeholder = "Placeholder.NewPassword".localizable.required.uppercased()
        confirmPasswordTextFieldView.placeholder = "Placeholder.ConfirmPassword".localizable.required.uppercased()
        updateButton.setTitle("Button.Update".localizable.uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        newPasswordTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.newPasswordText)
            .disposed(by: disposeBag)
        
        confirmPasswordTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.confirmPasswordText)
            .disposed(by: disposeBag)
        
        viewModel.newPasswordErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.newPasswordTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        viewModel.confirmPasswordErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.confirmPasswordTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        updateButton.rx.tap
            .bind(to: viewModel.updatePressed)
            .disposed(by: disposeBag)
        
        viewModel.updateButtonEnabled
            .subscribe(onNext: { [weak self] enabled in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.updateButton.isEnabled = enabled
            })
            .disposed(by: disposeBag)
        
        viewModel.updateSuccess.asObservable()
            .subscribe(onNext: { [weak self] success in
                guard let strongSelf = self, success else {
                    return
                }
                strongSelf.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
