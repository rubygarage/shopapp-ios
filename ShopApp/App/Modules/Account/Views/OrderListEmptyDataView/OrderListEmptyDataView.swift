//
//  OrderListEmptyDataView.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 2/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol OrderListEmptyDataViewDelegate: class {
    func viewDidTapStartShopping(_ view: OrderListEmptyDataView)
}

class OrderListEmptyDataView: UIView {
    @IBOutlet private weak var emptyOrderListLabel: UILabel!
    @IBOutlet private weak var startShoppingButton: UIButton!
    
    weak var delegate: OrderListEmptyDataViewDelegate?
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
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
        emptyOrderListLabel.text = "Label.NoOrdersYet".localizable
        startShoppingButton.setTitle("Button.StartShopping".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func startShoppingButtonDidPress(_ sender: UIButton) {
        delegate?.viewDidTapStartShopping(self)
    }
}
