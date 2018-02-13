//
//  PersonalInfoViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class PersonalInfoViewController: BaseViewController<PersonalInfoViewModel> {
    @IBOutlet private weak var nameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var lastNameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var emailTextFieldView: InputTextFieldView!
    @IBOutlet private weak var phoneTextFieldView: InputTextFieldView!
    @IBOutlet private weak var changePasswordButton: UnderlinedButton!
    @IBOutlet private weak var saveChangesButton: BlackButton!
    
    @IBOutlet fileprivate weak var changePasswordUnderlineView: UIView!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = PersonalInfoViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.PersonalInfo".localizable
        nameTextFieldView.placeholder = "Placeholder.Name".localizable.uppercased()
        lastNameTextFieldView.placeholder = "Placeholder.LastName".localizable.uppercased()
        emailTextFieldView.placeholder = "Placeholder.Email".localizable.required.uppercased()
        emailTextFieldView.setTextFieldEnabled(false)
        phoneTextFieldView.placeholder = "Placeholder.PhoneNumber".localizable.uppercased()
        changePasswordButton.setTitle("Button.ChangePassword".localizable.uppercased(), for: .normal)
        changePasswordButton.delegate = self
        saveChangesButton.setTitle("Button.SaveChanges".localizable.uppercased(), for: .normal)
    }
    
    private func setupViewModel() {
        viewModel.canChangeEmail = false
        
        viewModel.customer.asObservable()
            .subscribe(onNext: { [weak self] customer in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.populateViews(with: customer)
            })
            .disposed(by: disposeBag)
        
        nameTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.firstNameText)
            .disposed(by: disposeBag)
        
        emailTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        lastNameTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.lastNameText)
            .disposed(by: disposeBag)
        
        phoneTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        viewModel.emailErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.emailTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        changePasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.performSegue(withIdentifier: SegueIdentifiers.toChangePassword, sender: strongSelf)
            })
            .disposed(by: disposeBag)
        
        saveChangesButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        saveChangesButton.rx.tap
            .bind(to: viewModel.saveChangesPressed)
            .disposed(by: disposeBag)
        
        viewModel.saveChangesButtonEnabled
            .subscribe(onNext: { [weak self] enabled in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.saveChangesButton.isEnabled = enabled
            })
            .disposed(by: disposeBag)
        
        viewModel.saveChangesSuccess.asObservable()
            .subscribe(onNext: { [weak self] success in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.showToast(with: "Alert.ProfileChanged".localizable)
                strongSelf.saveChangesButton.isEnabled = !success
            })
            .disposed(by: disposeBag)
    }
    
    private func populateViews(with customer: Customer?) {
        guard let customer = customer else {
            return
        }
        nameTextFieldView.text = customer.firstName
        lastNameTextFieldView.text = customer.lastName
        emailTextFieldView.text = customer.email
        phoneTextFieldView.text = customer.phone
    }
    
    private func loadData() {
        viewModel.loadCustomer()
    }
}

// MARK: - UnderlinedButtonDelegate

extension PersonalInfoViewController: UnderlinedButtonDelegate {
    func underlinedButton(_ button: UnderlinedButton, didChangeState isHighlighted: Bool) {
        changePasswordUnderlineView.isHidden = isHighlighted
    }
}
