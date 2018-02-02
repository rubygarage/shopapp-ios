//
//  AddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class AddressFormViewController: BaseViewController<AddressFormViewModel> {
    @IBOutlet private weak var countryTextFieldView: InputTextFieldView!
    @IBOutlet private weak var nameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var lastNameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var addressTextFieldView: InputTextFieldView!
    @IBOutlet private weak var addressOptionalTextFieldView: InputTextFieldView!
    @IBOutlet private weak var cityTextFieldView: InputTextFieldView!
    @IBOutlet private weak var stateTextFieldView: InputTextFieldView!
    @IBOutlet private weak var zipCodeTextFieldView: InputTextFieldView!
    @IBOutlet private weak var phoneTextFieldView: InputTextFieldView!
    @IBOutlet private weak var submitButton: BlackButton!
    
    var address: Address?
    
    weak var delegate: AddressFormViewModelDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = AddressFormViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        populateViewsIfNeeded()
    }
    
    // MARK: - Setup
    
    private func setupViews() {        
        countryTextFieldView.placeholder = "Placeholder.Country".localizable.required.uppercased()
        nameTextFieldView.placeholder = "Placeholder.Name".localizable.required.uppercased()
        lastNameTextFieldView.placeholder = "Placeholder.LastName".localizable.required.uppercased()
        addressTextFieldView.placeholder = "Placeholder.Address".localizable.required.uppercased()
        addressOptionalTextFieldView.placeholder = "Placeholder.AddressOptional".localizable.uppercased()
        cityTextFieldView.placeholder = "Placeholder.City".localizable.required.uppercased()
        stateTextFieldView.placeholder = "Placeholder.State".localizable.uppercased()
        zipCodeTextFieldView.placeholder = "Placeholder.ZipCode".localizable.required.uppercased()
        phoneTextFieldView.placeholder = "Placeholder.PhoneNumber".localizable.required.uppercased()
        submitButton.setTitle("Button.Submit".localizable.uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        viewModel.address = address
        viewModel.delegate = delegate
        
        countryTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.countryText)
            .disposed(by: disposeBag)
        
        nameTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.firstNameText)
            .disposed(by: disposeBag)
        
        lastNameTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.lastNameText)
            .disposed(by: disposeBag)
        
        addressTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.addressText)
            .disposed(by: disposeBag)
        
        addressOptionalTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.addressOptionalText)
            .disposed(by: disposeBag)
        
        cityTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.cityText)
            .disposed(by: disposeBag)
        
        stateTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.stateText)
            .disposed(by: disposeBag)
        
        zipCodeTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.zipText)
            .disposed(by: disposeBag)
        
        phoneTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        viewModel.isAddressValid
            .subscribe(onNext: { [weak self] (isValid) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.submitButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitTapped)
            .disposed(by: disposeBag)
    }
    
    private func populateViewsIfNeeded() {
        if let address = viewModel.address {
            countryTextFieldView.text = address.country
            nameTextFieldView.text = address.firstName
            lastNameTextFieldView.text = address.lastName
            addressTextFieldView.text = address.address
            addressOptionalTextFieldView.text = address.secondAddress
            cityTextFieldView.text = address.city
            stateTextFieldView.text = address.state
            zipCodeTextFieldView.text = address.zip
            phoneTextFieldView.text = address.phone
            viewModel.updateFields()
        }
    }
}
