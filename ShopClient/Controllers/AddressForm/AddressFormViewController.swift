//
//  AddressFormViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

protocol AddressFormViewProtocol {
    func didUpdatedShippingAddress()
}

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
    
    var delegate: AddressFormViewProtocol?
    var checkoutId: String!
    
    override func viewDidLoad() {
        viewModel = AddressFormViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.AddNewAddress", comment: String())
        
        countryTextFieldView.placeholder = NSLocalizedString("Placeholder.Country", comment: String()).uppercased()
        nameTextFieldView.placeholder = NSLocalizedString("Placeholder.Name", comment: String()).uppercased()
        lastNameTextFieldView.placeholder = NSLocalizedString("Placeholder.LastName", comment: String()).uppercased()
        addressTextFieldView.placeholder = NSLocalizedString("Placeholder.Address", comment: String()).uppercased()
        addressOptionalTextFieldView.placeholder = NSLocalizedString("Placeholder.AddressOptional", comment: String()).uppercased()
        cityTextFieldView.placeholder = NSLocalizedString("Placeholder.City", comment: String()).uppercased()
        stateTextFieldView.placeholder = NSLocalizedString("Placeholder.State", comment: String()).uppercased()
        zipCodeTextFieldView.placeholder = NSLocalizedString("Placeholder.ZipCode", comment: String()).uppercased()
        phoneTextFieldView.placeholder = NSLocalizedString("Placeholder.PhoneNumber", comment: String()).uppercased()
        submitButton.setTitle(NSLocalizedString("Button.Submit", comment: String()).uppercased(), for: .normal)
        checkboxTitleLabel.text = NSLocalizedString("Label.DefaultShippingAddress", comment: String())
    }
    
    private func setupViewModel() {
        viewModel.checkoutId = checkoutId
        
        countryTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.countryText)
            .disposed(by: disposeBag)
        
        nameTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.firstNameText)
            .disposed(by: disposeBag)
        
        lastNameTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.lastNameText)
            .disposed(by: disposeBag)
        
        addressTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.addressText)
            .disposed(by: disposeBag)
        
        addressOptionalTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.addressOptionalText)
            .disposed(by: disposeBag)
        
        cityTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.cityText)
            .disposed(by: disposeBag)
        
        stateTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.stateText)
            .disposed(by: disposeBag)
        
        zipCodeTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.zipText)
            .disposed(by: disposeBag)
        
        phoneTextFieldView.textField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        viewModel.isAddressValid
            .subscribe(onNext: { [weak self] (isValid) in
                self?.submitButton.isEnabled = isValid
            })
            .disposed(by: disposeBag)
        
        viewModel.shippingAddressAdded
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didUpdatedShippingAddress()
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: viewModel.submitTapped)
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
}
