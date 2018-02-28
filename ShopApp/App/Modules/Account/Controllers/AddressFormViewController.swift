//
//  AddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

protocol AddressFormControllerlDelegate: class {
    func viewController(_ controller: AddressFormViewController, didFill address: Address)
}

class AddressFormViewController: BaseViewController<AddressFormViewModel> {
    @IBOutlet private weak var countryPicker: BasePicker!
    @IBOutlet private weak var nameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var lastNameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var addressTextFieldView: InputTextFieldView!
    @IBOutlet private weak var addressOptionalTextFieldView: InputTextFieldView!
    @IBOutlet private weak var cityTextFieldView: InputTextFieldView!
    @IBOutlet private weak var statePicker: BasePicker!
    @IBOutlet private weak var zipCodeTextFieldView: InputTextFieldView!
    @IBOutlet private weak var phoneTextFieldView: InputTextFieldView!
    @IBOutlet private weak var submitButton: BlackButton!
    @IBOutlet private weak var statePickerTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var statePickerHeightLayoutConstraint: NSLayoutConstraint!
    
    private let statePickerTopConstraint: CGFloat = 45
    private let statePickerHeightConstraint: CGFloat = 22
    
    var address: Address?
    
    weak var delegate: AddressFormControllerlDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        populateViewsIfNeeded()
        
        viewModel.getCountries()
    }
    
    // MARK: - Setup
    
    private func setupViews() {        
        countryPicker.placeholder = "Placeholder.Country".localizable.required.uppercased()
        nameTextFieldView.placeholder = "Placeholder.Name".localizable.required.uppercased()
        lastNameTextFieldView.placeholder = "Placeholder.LastName".localizable.required.uppercased()
        addressTextFieldView.placeholder = "Placeholder.Address".localizable.required.uppercased()
        addressOptionalTextFieldView.placeholder = "Placeholder.AddressOptional".localizable.uppercased()
        cityTextFieldView.placeholder = "Placeholder.City".localizable.required.uppercased()
        statePicker.placeholder = "Placeholder.State".localizable.uppercased()
        zipCodeTextFieldView.placeholder = "Placeholder.ZipCode".localizable.required.uppercased()
        phoneTextFieldView.placeholder = "Placeholder.PhoneNumber".localizable.required.uppercased()
        submitButton.setTitle("Button.Submit".localizable.uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        viewModel.address = address
        
        countryPicker.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.countryText)
            .disposed(by: disposeBag)
        
         countryPicker.rx.value.map({ $0 ?? "" })
            .subscribe(onNext: { [weak self] nameOfCountry in
                guard let strongSelf = self, !nameOfCountry.isEmpty else {
                    return
                }
                strongSelf.viewModel.updateStates(with: nameOfCountry)
            })
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
        
        statePicker.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.stateText)
            .disposed(by: disposeBag)
        
        viewModel.stateText.asObservable()
            .subscribe(onNext: { [weak self] nameOfState in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.statePicker.text = nameOfState
            })
            .disposed(by: disposeBag)
        
        zipCodeTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.zipText)
            .disposed(by: disposeBag)
        
        phoneTextFieldView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        viewModel.isAddressValid
            .subscribe(onNext: { [weak self] isValid in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.submitButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        viewModel.namesOfCountries
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.countryPicker.customData = data
            })
            .disposed(by: disposeBag)
        
        viewModel.namesOfStates
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.statePicker.customData = data
                strongSelf.statePicker.isHidden = data.isEmpty
                strongSelf.statePickerTopLayoutConstraint.constant = data.isEmpty ? 0 : strongSelf.statePickerTopConstraint
                strongSelf.statePickerHeightLayoutConstraint.constant = data.isEmpty ? 0 : strongSelf.statePickerHeightConstraint
            })
            .disposed(by: disposeBag)
        
        viewModel.filledAddress
            .subscribe(onNext: { [weak self] address in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.viewController(strongSelf, didFill: address)
            })
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitTapped)
            .disposed(by: disposeBag)
    }
    
    private func populateViewsIfNeeded() {
        if let address = viewModel.address {
            countryPicker.text = address.country
            nameTextFieldView.text = address.firstName
            lastNameTextFieldView.text = address.lastName
            addressTextFieldView.text = address.address
            addressOptionalTextFieldView.text = address.secondAddress
            cityTextFieldView.text = address.city
            statePicker.text = address.state
            zipCodeTextFieldView.text = address.zip
            phoneTextFieldView.text = address.phone
            viewModel.updateFields()
        }
    }
}
