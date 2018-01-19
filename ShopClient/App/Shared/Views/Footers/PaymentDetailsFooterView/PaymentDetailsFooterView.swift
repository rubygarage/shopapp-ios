//
//  PaymentDetailsFooterView.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/5/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentDetailsFooterView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var subtotalLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var shippingLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var subtotalValueLabel: UILabel!
    @IBOutlet private weak var discountValueLabel: UILabel!
    @IBOutlet private weak var shippingValueLabel: UILabel!
    @IBOutlet private weak var totalValueLabel: UILabel!
    
    static let height = CGFloat(175)
    
    // MARK: - View lifecycle
    
    init(order: Order) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        populateViews(order: order)
    }
    
    init(checkout: Checkout) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        populateViews(checkout: checkout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: PaymentDetailsFooterView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        subtotalLabel.text = "Label.Order.Subtotal".localizable
        discountLabel.text = "Label.Order.Discount".localizable
        shippingLabel.text = "Label.Order.Shipping".localizable
        totalLabel.text = "Label.Order.Total".localizable.uppercased()
    }
    
    private func populateViews(order: Order) {
        let formatter = NumberFormatter.formatter(with: order.currencyCode!)
        let subtotalPrice = NSDecimalNumber(decimal: order.subtotalPrice!)
        let discountPrice = NSDecimalNumber(value: 0)
        let totalShippingPrice = NSDecimalNumber(decimal: order.totalShippingPrice!)
        let totalPrice = NSDecimalNumber(decimal: order.totalPrice!)
        
        subtotalValueLabel.text = formatter.string(from: subtotalPrice)
        discountValueLabel.text = formatter.string(from: discountPrice)
        shippingValueLabel.text = formatter.string(from: totalShippingPrice)
        totalValueLabel.text = formatter.string(from: totalPrice)
    }
    
    private func populateViews(checkout: Checkout) {
        let formatter = NumberFormatter.formatter(with: checkout.currencyCode!)
        let subtotalPrice = NSDecimalNumber(decimal: checkout.subtotalPrice!)
        let discountPrice = NSDecimalNumber(value: 0)
        let totalShippingPrice = checkout.shippingLine == nil ? NSDecimalNumber(value: 0) : NSDecimalNumber(string: checkout.shippingLine?.price)
        let totalPrice = NSDecimalNumber(decimal: checkout.totalPrice!)
        
        subtotalValueLabel.text = formatter.string(from: subtotalPrice)
        discountValueLabel.text = formatter.string(from: discountPrice)
        shippingValueLabel.text = formatter.string(from: totalShippingPrice)
        totalValueLabel.text = formatter.string(from: totalPrice)
    }
}
