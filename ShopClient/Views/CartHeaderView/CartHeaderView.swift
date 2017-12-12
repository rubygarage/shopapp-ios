//
//  CartHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CartHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var totalItemsCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    init(productsCounts: Int, totalPrice: Float, currency: String) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        populateViews(with: productsCounts, totalPrice: totalPrice, currency: currency)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: CartHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func populateViews(with productsCount: Int, totalPrice: Float, currency: String) {
        let format = NSLocalizedString("OrdersCount", comment: String())
        totalItemsCountLabel.text = String.localizedStringWithFormat(format, productsCount)
        totalPriceLabel.text = "\(totalPrice) \(currency)"
    }
}
