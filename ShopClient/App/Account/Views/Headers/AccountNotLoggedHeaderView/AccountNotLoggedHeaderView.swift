//
//  AccountNotLoggedHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountNotLoggedHeaderDelegate: class {
    func headerViewDidTapSignIn(_ headerView: AccountNotLoggedHeaderView)
    func headerViewDidTapCreateNewAccount(_ headerView: AccountNotLoggedHeaderView)
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
        let viewName = String(describing: AccountNotLoggedHeaderView.self)
        Bundle.main.loadNibNamed(viewName, owner: self)
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
    
    @IBAction func signInButtonDidPress(_ sender: BlackButton) {
        delegate?.headerViewDidTapSignIn(self)
    }
    
    @IBAction func createNewAccountButtonDidPress(_ sender: UnderlinedButton) {
        delegate?.headerViewDidTapCreateNewAccount(self)
    }
}

// MARK: - UnderlinedButtonProtocol

extension AccountNotLoggedHeaderView: UnderlinedButtonProtocol {
    func didChangeState(isHighlighted: Bool) {
        createAccountUnderlinedView.isHidden = isHighlighted
    }
}
