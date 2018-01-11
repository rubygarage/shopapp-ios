//
//  LinkViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit
import RxSwift

class LinkViewController: BaseViewController<ForgorPasswordViewModel>, UnderlinedButtonProtocol {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var additionalTitleLabel: UILabel!
    @IBOutlet weak var additionalDescriptionLabel: UILabel!
    @IBOutlet weak var resendButton: UnderlinedButton!
    @IBOutlet weak var resendUnderlineView: UIView!
    
    var emailText = Variable<String>("")
    
    override func viewDidLoad() {
        viewModel = ForgorPasswordViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
    }
    
    private func setupViews() {
        titleLabel.text = "Label.ForgotPassword.LinkTitle".localizable
        descriptionLabel.text = "Label.ForgotPassword.LinkDescription".localizable
        additionalTitleLabel.text = "Label.ForgotPassword.LinkAdditionalTitle".localizable
        additionalDescriptionLabel.text = "Label.ForgotPassword.LinkAdditionalDescription".localizable
        resendButton.setTitle("Button.Resend".localizable.uppercased(), for: .normal)
        resendButton.delegate = self
        
        emailText.asObservable()
            .subscribe(onNext: { [weak self] emailText in
                self?.emailLabel.text = emailText
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
    
    // MARK: - UnderlinedButtonProtocol
    func didChangeState(isHighlighted: Bool) {
        resendUnderlineView.isHidden = isHighlighted
    }
}
