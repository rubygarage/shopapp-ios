//
//  OrderFooterView.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/4/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol OrderFooterViewProtocol {
    func viewDidTap(_ section: Int)
}

class OrderFooterView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var itemsLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    private var delegate: OrderFooterViewProtocol!
    private var section: Int!
    
    init(section: Int, order: Order, delegate: OrderFooterViewProtocol) {
        super.init(frame: CGRect.zero)
        
        self.section = section
        self.delegate = delegate
        commonInit()
        populateViews(order: order)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: OrderFooterView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        itemsLabel.text = NSLocalizedString("Label.Order.Items", comment: String())
        totalLabel.text = NSLocalizedString("Label.Order.TotalWithColon", comment: String()).uppercased()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        addGestureRecognizer(tap)
    }
    
    private func populateViews(order: Order) {
        countLabel.text = order.items != nil ? String(order.items!.flatMap { $0.quantity }.reduce(0, +)) : String(0)
        priceLabel.text = order.totalPrice!.description + " " + order.currencyCode!
    }
    
    func viewDidTap(gestureRecognizer: UIGestureRecognizer) {
        delegate.viewDidTap(section)
    }
}
