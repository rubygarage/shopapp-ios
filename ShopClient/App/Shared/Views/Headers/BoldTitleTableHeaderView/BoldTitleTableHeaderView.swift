//
//  BoldTitleTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum BoldTitleViewType {
    case customerEmail
    case shippingAddress
    case details
    case payment
    case shippingOptions
}

private let kTopMarginDefault: CGFloat = 15
private let kTopMarginPayment: CGFloat = 4

let kBoldTitleTableHeaderViewHeight: CGFloat = 75

class BoldTitleTableHeaderView: UIView {
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
        loadFromNib()
        setupConstraints()
        populateViews()
    }
    
    private func setupConstraints() {
        let lowMarginSectionTypes: [BoldTitleViewType] = [.payment, .shippingOptions]
        topMarginConstraint.constant = lowMarginSectionTypes.contains(headerViewType) ? kTopMarginPayment : kTopMarginDefault
    }
    
    private func populateViews() {
        switch headerViewType {
        case .customerEmail:
            headerTitleLabel.text = "Label.CustomerEmail".localizable
        case .shippingAddress:
            headerTitleLabel.text = "Label.ShippingAddress".localizable
        case BoldTitleViewType.details:
            headerTitleLabel.text = "Label.Details".localizable
        case .payment:
            headerTitleLabel.text = "Label.Payment".localizable
        case .shippingOptions:
            headerTitleLabel.text = "Label.ShippingOptions".localizable
        }
    }
}
