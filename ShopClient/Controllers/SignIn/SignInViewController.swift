//
//  SignInViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignInViewController: BaseViewController<SignInViewModel> {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        viewModel = SignInViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        addCloseButton()
        populateTitle()
    }
    
    private func populateTitle() {
        title = NSLocalizedString("ControllerTitle.SignIn", comment: String())
    }
    
    private func setupViewModel() {
        emailTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginPressed)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .subscribe(onNext: { [weak self] isValid in
                self?.loginButton.isEnabled = isValid
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
