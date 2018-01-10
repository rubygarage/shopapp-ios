//
//  BoldTitleTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum BoldTitleViewType {
    case shippingAddress
    case paymentInformation
    case payment
}

private let kTopMarginDefault: CGFloat = 15
private let kTopMarginPayment: CGFloat = 4

class BoldTitleTableHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    private var headerViewType = BoldTitleViewType.shippingAddress
    
    init(type: BoldTitleViewType) {
        super.init(frame: CGRect.zero)
        
        headerViewType = type
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: BoldTitleTableHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupConstraints()
        populateViews()
    }
    
    private func setupConstraints() {
        topMarginConstraint.constant = headerViewType == .payment ? kTopMarginPayment : kTopMarginDefault
    }
    
    private func populateViews() {
        switch headerViewType {
        case .shippingAddress:
            headerTitleLabel.text = NSLocalizedString("Label.ShippingAddress", comment: String())
        case BoldTitleViewType.paymentInformation:
            headerTitleLabel.text = NSLocalizedString("Label.PaymentInformation", comment: String())
        case .payment:
            headerTitleLabel.text = NSLocalizedString("Label.Payment", comment: String())
        }
    }
}
