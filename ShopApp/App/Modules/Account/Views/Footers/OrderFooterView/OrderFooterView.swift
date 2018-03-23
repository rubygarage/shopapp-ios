//
//  OrderFooterView.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

let kOrderFooterViewHeight: CGFloat = 60

protocol OrderFooterDelegate: class {
    func footerView(_ footerView: OrderFooterView, didTapWith section: Int)
}

class OrderFooterView: UIView {
    @IBOutlet private weak var itemsLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    private var section: Int!
    
    weak var delegate: OrderFooterDelegate?
    
    // MARK: - View lifecycle
    
    init(section: Int, order: Order) {
        super.init(frame: CGRect.zero)
        
        self.section = section
        commonInit()
        populateViews(order: order)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        loadFromNib()
        setupViews()
    }
    
    private func setupViews() {
        itemsLabel.text = "Label.Order.Items".localizable
        totalLabel.text = "Label.Order.TotalWithColon".localizable.uppercased()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        addGestureRecognizer(tap)
    }
    
    private func populateViews(order: Order) {
        let formatter = NumberFormatter.formatter(with: order.currencyCode!)
        let totalPrice = NSDecimalNumber(decimal: order.totalPrice!)
        
        countLabel.text = order.items != nil ? String(order.items!.flatMap { $0.quantity }.reduce(0, +)) : String(0)
        priceLabel.text = formatter.string(from: totalPrice)
    }
    
    // MARK: - Actions
    
    func viewDidTap(gestureRecognizer: UIGestureRecognizer) {
        delegate?.footerView(self, didTapWith: section)
    }
}
