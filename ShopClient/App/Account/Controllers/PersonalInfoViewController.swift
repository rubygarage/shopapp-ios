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
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = PersonalInfoViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: Present change password screen
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.PersonalInfo".localizable
        nameTextFieldView.placeholder = "Placeholder.Name".localizable.uppercased()
        lastNameTextFieldView.placeholder = "Placeholder.LastName".localizable.uppercased()
        emailTextFieldView.placeholder = "Placeholder.Email".localizable.required.uppercased()
        phoneTextFieldView.placeholder = "Placeholder.PhoneNumber".localizable.uppercased()
    }
    
    private func setupViewModel() {
        viewModel.customer.asObservable()
            .subscribe(onNext: { [weak self] customer in
                self?.populateViews(with: customer)
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
                self?.emailTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
    }
    
    private func populateViews(with customer: Customer?) {
        guard let customer = customer else {
            return
        }
        
        nameTextFieldView.textField.text = customer.firstName
        lastNameTextFieldView.textField.text = customer.lastName
        emailTextFieldView.textField.text = customer.email
        phoneTextFieldView.textField.text = customer.phone
    }
    
    private func loadData() {
        viewModel.loadCustomer()
    }
}
