//
//  AccountTableViewCell.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class AccountTableViewCell: UITableViewCell {
    @IBOutlet private weak var policyTitleLabel: UILabel!
    
    var type: AccountCustomerSection?
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    // MARK: - Setup
    
    func configure(with type: AccountCustomerSection) {
        self.type = type
        
        switch type {
        case .orders:
            policyTitleLabel.text = "Button.MyOrders".localizable
        case .info:
            policyTitleLabel.text = "Button.PersonalInfo".localizable
        default:
            policyTitleLabel.text = "Button.ShippingAddress".localizable
        }
    }
    
    func configure(with policy: Policy) {
        policyTitleLabel.text = policy.title
    }
}
