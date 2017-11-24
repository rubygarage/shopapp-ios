//
//  BillingAddressViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class BillingAddressViewController: BaseViewController<BillingAddressViewModel> {
    @IBOutlet weak var controllerTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        viewModel = BillingAddressViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        controllerTitleLabel.text = NSLocalizedString("ControllerTitle.BillingAddress", comment: String())
        cancelButton.setTitle(NSLocalizedString("Button.Cancel", comment: String()), for: .normal)
        nextButton.setTitle(NSLocalizedString("Button.PaymentAddressViewContinue", comment: String()), for: .normal)
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
        
        addressTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.addressText)
            .disposed(by: disposeBag)
        
        cityTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.cityText)
            .disposed(by: disposeBag)
        
        countryTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.countryText)
            .disposed(by: disposeBag)
        
        zipTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.zipText)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .subscribe(onNext: { [weak self] isValid in
                self?.nextButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // TODO:
    }
}
