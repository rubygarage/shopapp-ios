//
//  AccountFooterView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol AccountFooterViewProtocol: class {
    func didTapLogout()
}

class AccountFooterView: UIView, UnderlinedButtonProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var logoutButton: UnderlinedButton!
    @IBOutlet weak var logoutUnderlineView: UIView!
    
    weak var delegate: AccountFooterViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        logoutButton.setTitle("Button.Logout".localizable.uppercased(), for: .normal)
        logoutButton.delegate = self
    }
    
    // MARK: - Action
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        delegate?.didTapLogout()
    }
    
    // MARK: - UnderlinedButtonProtocol
    
    func didChangeState(isHighlighted: Bool) {
        logoutUnderlineView.isHidden = isHighlighted
    }
}
