//
//  OrderHeaderView.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopClient_Gateway

let kOrderHeaderViewHeight: CGFloat = 75

protocol OrderHeaderDelegate: class {
    func headerView(_ headerView: OrderHeaderView, didTapWith section: Int)
}

class OrderHeaderView: UIView {
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private var section: Int!
    
    weak var delegate: OrderHeaderDelegate?
    
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        addGestureRecognizer(tap)
    }
    
    private func populateViews(order: Order) {
        let numberFormat = "Label.Order.Number".localizable.uppercased()
        numberLabel.text = String(format: numberFormat, String(order.number!))
        let dateFormat = "Label.Order.Date".localizable
        dateLabel.text = String(format: dateFormat, order.createdAt!.longDescription)
    }
    
    // MARK: - Actions
    
    func viewDidTap(gestureRecognizer: UIGestureRecognizer) {
        delegate?.headerView(self, didTapWith: section)
    }
}
