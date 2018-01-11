//
//  AddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class AddressFormViewController: BaseViewController<AddressFormViewModel> {
    @IBOutlet weak var countryTextFieldView: InputTextFieldView!
    @IBOutlet weak var nameTextFieldView: InputTextFieldView!
    @IBOutlet weak var lastNameTextFieldView: InputTextFieldView!
    @IBOutlet weak var addressTextFieldView: InputTextFieldView!
    @IBOutlet weak var addressOptionalTextFieldView: InputTextFieldView!
    @IBOutlet weak var cityTextFieldView: InputTextFieldView!
    @IBOutlet weak var stateTextFieldView: InputTextFieldView!
    @IBOutlet weak var zipCodeTextFieldView: InputTextFieldView!
    @IBOutlet weak var phoneTextFieldView: InputTextFieldView!
    @IBOutlet weak var submitButton: BlackButton!
    @IBOutlet weak var defaultAddressButton: CheckboxButton!
    @IBOutlet weak var checkboxTitleLabel: UILabel!
    
    var address: Address?
    var completion: AddressFormCompletion?
    
    override func viewDidLoad() {
        viewModel = AddressFormViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        populateViewsIfNeeded()
    }
    
    private func setupViews() {
        title = "ControllerTitle.AddNewAddress".localizable
        
        countryTextFieldView.placeholder = "Placeholder.Country".localizable.uppercased()
        nameTextFieldView.placeholder = "Placeholder.Name".localizable.uppercased()
        lastNameTextFieldView.placeholder = "Placeholder.LastName".localizable.uppercased()
        addressTextFieldView.placeholder = "Placeholder.Address".localizable.uppercased()
        addressOptionalTextFieldView.placeholder = "Placeholder.AddressOptional".localizable.uppercased()
        cityTextFieldView.placeholder = "Placeholder.City".localizable.uppercased()
        stateTextFieldView.placeholder = "Placeholder.State".localizable.uppercased()
        zipCodeTextFieldView.placeholder = "Placeholder.ZipCode".localizable.uppercased()
        phoneTextFieldView.placeholder = "Placeholder.PhoneNumber".localizable.uppercased()
        submitButton.setTitle("Button.Submit".localizable.uppercased(), for: .normal)
        checkboxTitleLabel.text = "Label.DefaultShippingAddress".localizable
    }
    
    private func setupViewModel() {
        viewModel.address = address
        viewModel.completion = completion
        
        countryTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.countryText)
            .disposed(by: disposeBag)
        
        nameTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.firstNameText)
            .disposed(by: disposeBag)
        
        lastNameTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.lastNameText)
            .disposed(by: disposeBag)
        
        addressTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.addressText)
            .disposed(by: disposeBag)
        
        addressOptionalTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.addressOptionalText)
            .disposed(by: disposeBag)
        
        cityTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.cityText)
            .disposed(by: disposeBag)
        
        stateTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.stateText)
            .disposed(by: disposeBag)
        
        zipCodeTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.zipText)
            .disposed(by: disposeBag)
        
        phoneTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        viewModel.isAddressValid
            .subscribe(onNext: { [weak self] (isValid) in
                self?.submitButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitTapped)
            .disposed(by: disposeBag)
        
        viewModel.addressSubmitted
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.useDefaultShippingAddress.asObservable()
            .subscribe(onNext: { [weak self] (selected) in
                self?.defaultAddressButton.isSelected = selected
            })
            .disposed(by: disposeBag)
        
        defaultAddressButton.rx.tap
            .bind(to: viewModel.useDefaultAddressTapped)
            .disposed(by: disposeBag)
    }
    
    private func populateViewsIfNeeded() {
        if let address = viewModel.address {
            countryTextFieldView.textField.text = address.country
            nameTextFieldView.textField.text = address.firstName
            lastNameTextFieldView.textField.text = address.lastName
            addressTextFieldView.textField.text = address.address
            addressOptionalTextFieldView.textField.text = address.secondAddress
            cityTextFieldView.textField.text = address.city
            stateTextFieldView.textField.text = address.state
            zipCodeTextFieldView.textField.text = address.zip
            phoneTextFieldView.textField.text = address.phone
            viewModel.updateFields()
        }
    }
}
