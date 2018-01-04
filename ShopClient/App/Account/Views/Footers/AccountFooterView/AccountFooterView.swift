//
//  AccountFooterView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountFooterViewProtocol {
    func didTapLogout()
}

class AccountFooterView: UIView, UnderlinedButtonProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var logoutButton: UnderlinedButton!
    @IBOutlet weak var logoutUnderlineView: UIView!
    
    private var footerDelegate: AccountFooterViewProtocol!
    
    init(delegate: AccountFooterViewProtocol) {
        super.init(frame: CGRect.zero)
        
        footerDelegate = delegate
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: AccountFooterView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        logoutButton.setTitle(NSLocalizedString("Button.Logout", comment: String()).uppercased(), for: .normal)
        logoutButton.delegate = self
    }
    
    // MARK: - action
    @IBAction func logoutTapped(_ sender: UIButton) {
        footerDelegate.didTapLogout()
    }
    
    // MARK: - UnderlinedButtonProtocol
    func didChangeState(isHighlighted: Bool) {
        logoutUnderlineView.isHidden = isHighlighted
    }
}
