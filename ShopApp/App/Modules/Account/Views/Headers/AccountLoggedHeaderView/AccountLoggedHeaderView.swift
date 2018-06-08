//
//  AccountLoggedHeaderView.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/11/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import AvatarImageView
import ShopApp_Gateway

private let kAvatarTextSizeFactor: CGFloat = 0.4

let kAccountLoggedHeaderViewHeight: CGFloat = 109

private struct CustomerImageConfig: AvatarImageViewConfiguration {
    let shape: Shape = .circle
    let bgColor: UIColor? = UIColor.black
    let textSizeFactor: CGFloat = kAvatarTextSizeFactor
}

private struct CustomerImageDataSource: AvatarImageViewDataSource {
    var name: String
    
    init(customerName: String) {
        name = customerName
    }
}

class AccountLoggedHeaderView: UIView {
    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var customerNameLabel: UILabel!
    
    @IBOutlet private weak var customerImageView: AvatarImageView! {
        didSet {
            customerImageView.configuration = CustomerImageConfig()
        }
    }
    
    // MARK: - View lifecycle
    
    init(frame: CGRect, customer: Customer) {
        super.init(frame: frame)
        
        commonInit()
        populateViews(customer: customer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        loadFromNib()
        setupViews()
    }
    
    private func setupViews() {
        welcomeLabel.text = "Label.Welcome".localizable
    }
    
    private func populateViews(customer: Customer) {
        customerNameLabel.text = customer.fullName
        customerImageView.dataSource = CustomerImageDataSource(customerName: customer.fullName)
    }
}
