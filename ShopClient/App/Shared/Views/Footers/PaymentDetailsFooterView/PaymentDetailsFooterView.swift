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
        subtotalValueLabel.text = order.subtotalPrice!.description + " " + order.currencyCode!
        discountValueLabel.text = String(0) + " " + order.currencyCode!
        shippingValueLabel.text = order.totalShippingPrice!.description + " " + order.currencyCode!
        taxValueLabel.text = order.totalTax!.description + " " + order.currencyCode!
        totalValueLabel.text = order.totalPrice!.description + " " + order.currencyCode!
    }

}
