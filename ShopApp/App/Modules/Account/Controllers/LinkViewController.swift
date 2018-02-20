//
//  LinkViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxSwift

class LinkViewController: BaseViewController<ForgotPasswordViewModel> {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var additionalTitleLabel: UILabel!
    @IBOutlet private weak var additionalDescriptionLabel: UILabel!
    @IBOutlet private weak var resendButton: UnderlinedButton!
    
    @IBOutlet fileprivate weak var resendUnderlineView: UIView!
    
    var emailText = Variable<String>("")
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        titleLabel.text = "Label.ForgotPassword.LinkTitle".localizable
        descriptionLabel.text = "Label.ForgotPassword.LinkDescription".localizable
        additionalTitleLabel.text = "Label.ForgotPassword.LinkAdditionalTitle".localizable
        additionalDescriptionLabel.text = "Label.ForgotPassword.LinkAdditionalDescription".localizable
        resendButton.setTitle("Button.Resend".localizable.uppercased(), for: .normal)
        resendButton.delegate = self
        
        emailText.asObservable()
            .subscribe(onNext: { [weak self] emailText in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.emailLabel.text = emailText
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        emailText.asObservable()
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        resendButton.rx.tap
            .bind(to: viewModel.resetPasswordPressed)
            .disposed(by: disposeBag)
    }
}

// MARK: - UnderlinedButtonDelegate

extension LinkViewController: UnderlinedButtonDelegate {
    func underlinedButton(_ button: UnderlinedButton, didChangeState isHighlighted: Bool) {
        resendUnderlineView.isHidden = isHighlighted
    }
}
