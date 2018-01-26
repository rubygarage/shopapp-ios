//
//  AccountFooterView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountFooterViewDelegate: class {
    func didTapLogout()
}

class AccountFooterView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var logoutButton: UnderlinedButton!
    
    @IBOutlet fileprivate weak var logoutUnderlineView: UIView!
    
    weak var delegate: AccountFooterViewDelegate?
    
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
        Bundle.main.loadNibNamed(String(describing: AccountFooterView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        logoutButton.setTitle("Button.Logout".localizable.uppercased(), for: .normal)
        logoutButton.delegate = self
    }
    
    // MARK: - Action
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        delegate?.didTapLogout()
    }
}

// MARK: - UnderlinedButtonProtocol

extension AccountFooterView: UnderlinedButtonProtocol {
    func didChangeState(isHighlighted: Bool) {
        logoutUnderlineView.isHidden = isHighlighted
    }
}
