//
//  AccountTableViewCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class AccountTableViewCell: UITableViewCell {
    @IBOutlet private weak var policyTitleLabel: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Setup
    
    func configure(with policy: Policy) {
        policyTitleLabel.text = policy.title
    }
}
