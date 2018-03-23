//
//  CartHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CartHeaderView: UIView {
    @IBOutlet private weak var totalItemsCountLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    // MARK: - View lifecycle
    
    init(productsCounts: Int, totalPrice: Float, currency: String) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        populateViews(with: productsCounts, totalPrice: totalPrice, currency: currency)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        loadFromNib()
    }
    
    private func populateViews(with productsCount: Int, totalPrice: Float, currency: String) {
        let formatter = NumberFormatter.formatter(with: currency)
        let price = NSDecimalNumber(decimal: Decimal(Double(totalPrice)))
        let format = "OrdersCount".localizable
        totalItemsCountLabel.text = String.localizedStringWithFormat(format, productsCount)
        totalPriceLabel.text = formatter.string(from: price)
    }
}
