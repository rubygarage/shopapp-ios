//
//  LoginViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class LoginViewController: BaseViewController<LoginViewModel> {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        viewModel = LoginViewModel()
        super.viewDidLoad()
        
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateTitle()
    }
    
    private func populateTitle() {
        self.tabBarController?.navigationItem.title = NSLocalizedString("ControllerTitle.Login", comment: String())
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
        
        viewModel.isValid
            .subscribe(onNext: { [weak self] isValid in
                self?.loginButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        viewModel.loginSuccess.asObservable()
            .subscribe(onNext: { success in
                print("ddddd")
            })
            .disposed(by: disposeBag)
    }
}
