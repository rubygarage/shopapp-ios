//
//  AccountNotLoggedHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountNotLoggedHeaderDelegate: class {
    func didTapSignIn()
    func didTapCreateNewAccount()
}

class AccountNotLoggedHeaderView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var signInButton: BlackButton!
    @IBOutlet private weak var signInLabel: UILabel!
    @IBOutlet private weak var createNewAccountButton: UnderlinedButton!
    
    @IBOutlet fileprivate weak var createAccountUnderlinedView: UIView!
    
    weak var delegate: AccountNotLoggedHeaderDelegate?
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: AccountNotLoggedHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        signInButton.setTitle("Button.SignIn".localizable.uppercased(), for: .normal)
        signInLabel.text = "Label.SignInToShop".localizable
        createNewAccountButton.setTitle("Button.CreateNewAccount".localizable.uppercased(), for: .normal)
        createNewAccountButton.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func signInTapped(_ sender: BlackButton) {
        delegate?.didTapSignIn()
    }
    
    @IBAction func createNewAccountTapped(_ sender: UnderlinedButton) {
        delegate?.didTapCreateNewAccount()
    }
}

// MARK: - UnderlinedButtonProtocol

extension AccountNotLoggedHeaderView: UnderlinedButtonProtocol {
    func didChangeState(isHighlighted: Bool) {
        createAccountUnderlinedView.isHidden = isHighlighted
    }
}
