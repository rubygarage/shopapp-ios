//
//  PaymentDetailsFooterView.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/5/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentDetailsFooterView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var shippingLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var subtotalValueLabel: UILabel!
    @IBOutlet var discountValueLabel: UILabel!
    @IBOutlet var shippingValueLabel: UILabel!
    @IBOutlet var totalValueLabel: UILabel!
    
    static let height = CGFloat(175)
    
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
        let totalShippingPrice = NSDecimalNumber(value: 0)
        let totalPrice = NSDecimalNumber(decimal: checkout.totalPrice!)
        
        subtotalValueLabel.text = formatter.string(from: subtotalPrice)
        discountValueLabel.text = formatter.string(from: discountPrice)
        shippingValueLabel.text = formatter.string(from: totalShippingPrice)
        totalValueLabel.text = formatter.string(from: totalPrice)
    }
}
