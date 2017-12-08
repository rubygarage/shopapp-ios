//
//  SignInViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignInViewController: BaseViewController<SignInViewModel> {
    @IBOutlet weak var emailTextFieldView: InputTextFieldView!
    @IBOutlet weak var passwordTextFieldView: InputTextFieldView!
    @IBOutlet weak var signInButton: BlackButton!
    
    override func viewDidLoad() {
        viewModel = SignInViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        addCloseButton()
        title = NSLocalizedString("ControllerTitle.SignIn", comment: String())
        emailTextFieldView.textField.placeholder = NSLocalizedString("Placeholder.Email", comment: String()).uppercased()
        passwordTextFieldView.textField.placeholder = NSLocalizedString("Placeholder.Password", comment: String()).uppercased()
        signInButton.setTitle(NSLocalizedString("Button.SignIn", comment: String()).uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        emailTextFieldView.textField
            .rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .bind(to: viewModel.loginPressed)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .subscribe(onNext: { [weak self] isValid in
                self?.signInButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        viewModel.loginSuccess.asObservable()
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.setHomeController()
                }
            })
            .disposed(by: disposeBag)
    }
}
