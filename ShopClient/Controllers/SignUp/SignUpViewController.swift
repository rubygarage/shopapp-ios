//
//  SignUpViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class SignUpViewController: BaseViewController<SignUpViewModel> {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        viewModel = SignUpViewModel()
        super.viewDidLoad()

        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateTitle()
    }
    
    private func populateTitle() {
        self.tabBarController?.navigationItem.title = NSLocalizedString("ControllerTitle.SignUp", comment: String())
    }
    
    private func setupViewModel() {
        emailTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        firstNameTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.firstNameText)
            .disposed(by: disposeBag)
        
        lastNameTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.lastNameText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.signUpPressed)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .subscribe(onNext: { [weak self] isValid in
                self?.signUpButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        viewModel.signInSuccess.asObservable()
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.setHomeController()
                }
            })
            .disposed(by: disposeBag)
    }
}
