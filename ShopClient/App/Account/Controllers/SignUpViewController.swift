//
//  SignUpViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift
import TTTAttributedLabel

class SignUpViewController: BaseViewController<SignUpViewModel>, TTTAttributedLabelDelegate {
    @IBOutlet private weak var emailTextFieldView: InputTextFieldView!
    @IBOutlet private weak var nameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var lastNameTextFieldView: InputTextFieldView!
    @IBOutlet private weak var phoneTextFieldView: InputTextFieldView!
    @IBOutlet private weak var passwordTextFieldView: InputTextFieldView!
    @IBOutlet private weak var signUpButton: BlackButton!
    @IBOutlet private weak var acceptPoliciesLabel: TTTAttributedLabel!
    
    private var selectedPolicy: Policy?
    
    weak var delegate: AuthenticationProtocol?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = SignUpViewModel()
        viewModel.delegate = delegate
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let policyViewController = segue.destination as? PolicyViewController {
            policyViewController.policy = selectedPolicy
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        addCloseButton()
        title = "ControllerTitle.SignUp".localizable
        emailTextFieldView.placeholder = "Placeholder.Email".localizable.required.uppercased()
        nameTextFieldView.placeholder = "Placeholder.Name".localizable.uppercased()
        lastNameTextFieldView.placeholder = "Placeholder.LastName".localizable.uppercased()
        phoneTextFieldView.placeholder = "Placeholder.PhoneNumber".localizable.uppercased()
        passwordTextFieldView.placeholder = "Placeholder.CreatePassword".localizable.required.uppercased()
        signUpButton.setTitle("Button.CreateNewAccount".localizable.uppercased(), for: .normal)
        
        let text = "Label.AcceptPoliciesAttributed".localizable
        let privacyPolicy = "Label.Range.PrivacyPolicy".localizable
        let termsOfService = "Label.Range.TermsOfService".localizable
        acceptPoliciesLabel.setup(with: text, links: [privacyPolicy, termsOfService], delegate: self)
    }
    
    private func setupViewModel() {
        emailTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        nameTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.firstNameText)
            .disposed(by: disposeBag)
        
        lastNameTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.lastNameText)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        phoneTextFieldView.textField.rx.text.map({ $0 ?? "" })
            .bind(to: viewModel.phoneText)
            .disposed(by: disposeBag)
        
        viewModel.emailErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.emailTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        viewModel.passwordErrorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                self?.passwordTextFieldView.errorMessage = errorMessage
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.signUpPressed)
            .disposed(by: disposeBag)
        
        viewModel.signUpButtonEnabled
            .subscribe(onNext: { [weak self] enabled in
                self?.signUpButton.isEnabled = enabled
            })
            .disposed(by: disposeBag)
        
        viewModel.signUpSuccess.asObservable()
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.policies.asObservable()
            .subscribe(onNext: { [weak self] (privacyPolicy, termsOfService) in
                self?.populateAgreementsLabel(with: privacyPolicy, termsOfService: termsOfService)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadPolicies()
    }
    
    private func populateAgreementsLabel(with privacyPolicy: Policy?, termsOfService: Policy?) {
        acceptPoliciesLabel.isHidden = privacyPolicy == nil && termsOfService == nil
    }
    
    // MARK: - TTTAttributedLabelDelegate
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let privacyPolicy = "Label.Range.PrivacyPolicy".localizable.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let termsOfService = "Label.Range.TermsOfService".localizable.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        if url.absoluteString == privacyPolicy, let privacyPolicy = viewModel.policies.value.privacyPolicy {
            selectedPolicy = privacyPolicy
            performSegue(withIdentifier: SegueIdentifiers.toPolicy, sender: self)
        } else if url.absoluteString == termsOfService, let termsOfService = viewModel.policies.value.termsOfService {
            selectedPolicy = termsOfService
            performSegue(withIdentifier: SegueIdentifiers.toPolicy, sender: self)
        }
    }
}
