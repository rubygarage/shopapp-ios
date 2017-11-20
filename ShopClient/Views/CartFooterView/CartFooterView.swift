//
//  CartFooterView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CartFooterProtocol {
    func didTapProceed()
}

class CartFooterView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var delegate: CartFooterProtocol?
    
    init(productsCounts: Int, totalPrice: Float, currency: String, delegate: CartFooterProtocol?) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        self.delegate = delegate
        populateViews(with: productsCounts, totalPrice: totalPrice, currency: currency)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: CartFooterView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        proceedButton.setTitle(NSLocalizedString("Button.Proceed", comment: String()), for: .normal)
    }
    
    private func populateViews(with productsCount: Int, totalPrice: Float, currency: String) {
        let format = NSLocalizedString("OrdersCount", comment: String())
        let message = String.localizedStringWithFormat(format, productsCount)
        
        orderTotalLabel.text = message
        
//        orderTotalLabel.text = "O t\(productsCount)"
        totalPriceLabel.text = "\(totalPrice) \(currency)"
    }
    
    // MARK: - actions
    @IBAction func proceedTapped(_ sender: UIButton) {
        delegate?.didTapProceed()
    }
}
