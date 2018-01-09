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
    @IBOutlet var taxLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var subtotalValueLabel: UILabel!
    @IBOutlet var discountValueLabel: UILabel!
    @IBOutlet var shippingValueLabel: UILabel!
    @IBOutlet var taxValueLabel: UILabel!
    @IBOutlet var totalValueLabel: UILabel!
    
    static let height = CGFloat(175)
    
    init(order: Order) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        populateViews(order: order)
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
        subtotalLabel.text = NSLocalizedString("Label.Order.Subtotal", comment: String())
        discountLabel.text = NSLocalizedString("Label.Order.Discount", comment: String())
        shippingLabel.text = NSLocalizedString("Label.Order.Shipping", comment: String())
        taxLabel.text = NSLocalizedString("Label.Order.Tax", comment: String())
        totalLabel.text = NSLocalizedString("Label.Order.Total", comment: String()).uppercased()
    }
    
    private func populateViews(order: Order) {
        let subtotalPrice = NSDecimalNumber(decimal: order.subtotalPrice!).doubleValue
        let totalShippingPrice = NSDecimalNumber(decimal: order.totalShippingPrice!).doubleValue
        let totalTax = NSDecimalNumber(decimal: order.totalTax!).doubleValue
        let totalPrice = NSDecimalNumber(decimal: order.totalPrice!).doubleValue
        let currency = order.currencyCode!
        
        subtotalValueLabel.text = String(format: "%.2f %@", subtotalPrice, currency)
        discountValueLabel.text = String(format: "%.2f %@", 0.0, currency)
        shippingValueLabel.text = String(format: "%.2f %@", totalShippingPrice, currency)
        taxValueLabel.text = String(format: "%.2f %@", totalTax, currency)
        totalValueLabel.text = String(format: "%.2f %@", totalPrice, currency)
    }

}
