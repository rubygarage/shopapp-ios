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
    case shippingOptions
}

private let kTopMarginDefault: CGFloat = 15
private let kTopMarginPayment: CGFloat = 4

class BoldTitleTableHeaderView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var topMarginConstraint: NSLayoutConstraint!
    
    private var headerViewType = BoldTitleViewType.shippingAddress
    
    // MARK: - View lifecycle
    
    init(type: BoldTitleViewType, disabled: Bool = false) {
        super.init(frame: CGRect.zero)
        
        headerViewType = type
        commonInit()
        headerTitleLabel.textColor = disabled ? UIColor.gray : UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: BoldTitleTableHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupConstraints()
        populateViews()
    }
    
    private func setupConstraints() {
        let lowMarginSectionTypes: [BoldTitleViewType] = [.payment, .shippingOptions]
        topMarginConstraint.constant = lowMarginSectionTypes.contains(headerViewType) ? kTopMarginPayment : kTopMarginDefault
    }
    
    private func populateViews() {
        switch headerViewType {
        case .shippingAddress:
            headerTitleLabel.text = "Label.ShippingAddress".localizable
        case BoldTitleViewType.paymentInformation:
            headerTitleLabel.text = "Label.PaymentInformation".localizable
        case .payment:
            headerTitleLabel.text = "Label.Payment".localizable
        case .shippingOptions:
            headerTitleLabel.text = "Label.ShippingOptions".localizable
        }
    }
}
