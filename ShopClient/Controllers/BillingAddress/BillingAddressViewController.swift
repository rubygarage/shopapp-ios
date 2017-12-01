//
//  BillingAddressViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/28/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

protocol BillingAddressViewProtocol {
    func didFilled(billingAddress: Address)
}

class BillingAddressViewController: BaseViewController<BillingAddressViewModel> {
    @IBOutlet weak var controllerTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var useSameAddressLabel: UILabel!
    @IBOutlet weak var useSameAddressSwitch: UISwitch!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var textFields: [UITextField] {
        get {
            return [firstNameTextField, lastNameTextField, addressTextField, cityTextField, countryTextField, zipTextField, phoneTextField]
        }
    }
    var delegate: BillingAddressViewProtocol?
    var preloadedAddress: Address!
    
    override func viewDidLoad() {
        viewModel = BillingAddressViewModel()
        viewModel.preloadedAddress = preloadedAddress
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        controllerTitleLabel.text = NSLocalizedString("ControllerTitle.BillingAddress", comment: String())
        cancelButton.setTitle(NSLocalizedString("Button.Cancel", comment: String()), for: .normal)
        useSameAddressLabel.text = NSLocalizedString("Label.SameAsShippingAddress", comment: String())
        nextButton.setTitle(NSLocalizedString("Button.PaymentAddressViewContinue", comment: String()), for: .normal)
    }
    
    private func setupViewModel() {        
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
        
        useSameAddressSwitch.rx.isOn
            .bind(to: viewModel.useSameAddressChanged)
            .disposed(by: disposeBag)
        
        viewModel.useSameAddress.asObservable()
            .subscribe(onNext: { [weak self] useSameAddress in
                self?.textFields.forEach({ $0.isEnabled = !useSameAddress })
            })
            .disposed(by: disposeBag)
        
        viewModel.usedAddress.asObservable()
            .subscribe(onNext: { [weak self] address in
                self?.updateTextFields(with: address)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateTextFields(with address: Address?) {
        firstNameTextField.text = address?.firstName
        lastNameTextField.text = address?.lastName
        addressTextField.text = address?.address
        cityTextField.text = address?.city
        countryTextField.text = address?.country
        zipTextField.text = address?.zip
        phoneTextField.text = address?.phone
    }
    
    // MARK: - actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let address = viewModel.getAddress()
        delegate?.didFilled(billingAddress: address)
        dismiss(animated: true)
    }
}
