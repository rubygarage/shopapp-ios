//
//  SignUpViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignUpViewController: BaseViewController<SignUpViewModel> {
    @IBOutlet weak var emailTextFieldView: InputTextFieldView!
    @IBOutlet weak var nameTextFieldView: InputTextFieldView!
    @IBOutlet weak var lastNameTextFieldView: InputTextFieldView!
    @IBOutlet weak var phoneTextFieldView: InputTextFieldView!
    @IBOutlet weak var passwordTextFieldView: InputTextFieldView!
    @IBOutlet weak var signUpButton: BlackButton!
    
    var delegate: SignUpViewModelProtocol!
    
    override func viewDidLoad() {
        viewModel = SignUpViewModel()
        viewModel.delegate = delegate
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        addCloseButton()
        title = NSLocalizedString("ControllerTitle.SignUp", comment: String())
        emailTextFieldView.placeholder = NSLocalizedString("Placeholder.Email", comment: String()).uppercased()
        nameTextFieldView.placeholder = NSLocalizedString("Placeholder.Name", comment: String()).uppercased()
        lastNameTextFieldView.placeholder = NSLocalizedString("Placeholder.LastName", comment: String()).uppercased()
        phoneTextFieldView.placeholder = NSLocalizedString("Placeholder.PhoneNumber", comment: String()).uppercased()
        passwordTextFieldView.placeholder = NSLocalizedString("Placeholder.CreatePassword", comment: String()).uppercased()
        signUpButton.setTitle(NSLocalizedString("Button.SignUp", comment: String()).uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        emailTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        nameTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.firstNameText)
            .disposed(by: disposeBag)
        
        lastNameTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.lastNameText)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        phoneTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        viewModel.emailErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.emailTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        viewModel.passwordErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.passwordTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.signUpPressed)
            .disposed(by: disposeBag)
        
        viewModel.signUpButtonEnabled
            .subscribe(onNext: { [weak self] enabled in
                self?.signUpButton.isEnabled = enabled
            })
            .disposed(by: disposeBag)
        
        viewModel.signUpSuccess.asObservable()
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
