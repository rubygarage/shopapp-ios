//
//  AccountFooterView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kAccountFooterViewHeight: CGFloat = 65

protocol AccountFooterDelegate: class {
    func footerViewDidTapLogout(_ footerView: AccountFooterView)
}

class AccountFooterView: UITableViewHeaderFooterView, UnderlinedButtonDelegate {
    @IBOutlet private weak var logoutButton: UnderlinedButton!
    
    @IBOutlet fileprivate weak var logoutUnderlineView: UIView!
    
    weak var delegate: AccountFooterDelegate?
    
    // MARK: - View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        setupViews()
    }
    
    private func setupViews() {
        logoutButton.setTitle("Button.Logout".localizable.uppercased(), for: .normal)
        logoutButton.delegate = self
    }
    
    // MARK: - Action
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        delegate?.footerViewDidTapLogout(self)
    }

    // MARK: - UnderlinedButtonDelegate

    func underlinedButton(_ button: UnderlinedButton, didChangeState isHighlighted: Bool) {
        logoutUnderlineView.isHidden = isHighlighted
    }
}
