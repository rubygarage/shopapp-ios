//
//  AccountLoggedHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/11/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import AvatarImageView

protocol AccountLoggedHeaderProtocol: class {
    func didTapMyOrders()
}

private let kAvatarTextSizeFactor: CGFloat = 0.4

struct CustomerImageConfig: AvatarImageViewConfiguration {
    let shape: Shape = .circle
    let bgColor: UIColor? = UIColor.black
    let textSizeFactor: CGFloat = kAvatarTextSizeFactor
}

struct CustomerImageDataSource: AvatarImageViewDataSource {
    var name: String
    
    init(customerName: String) {
        name = customerName
    }
}

class AccountLoggedHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var myOrdersButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerImageView: AvatarImageView! {
        didSet {
            customerImageView.configuration = CustomerImageConfig()
        }
    }
    
    weak var delegate: AccountLoggedHeaderProtocol?
    
    init(customer: Customer) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        populateViews(customer: customer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: AccountLoggedHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        myOrdersButton.setTitle("Button.MyOrders".localizable, for: .normal)
        welcomeLabel.text = "Label.Welcome".localizable
    }
    
    private func populateViews(customer: Customer) {
        customerNameLabel.text = customer.fullname
        customerImageView.dataSource = CustomerImageDataSource(customerName: customer.fullname)
    }
    
    // MARK: - Actions
    
    @IBAction func myOrdersTapped(_ sender: UIButton) {
        delegate?.didTapMyOrders()
    }
}
