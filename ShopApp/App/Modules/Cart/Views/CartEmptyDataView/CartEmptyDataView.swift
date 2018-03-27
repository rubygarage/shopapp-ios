//
//  CartEmptyDataView.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/12/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CartEmptyDataViewDelegate: class {
    func viewDidTapStartShopping(_ view: CartEmptyDataView)
}

class CartEmptyDataView: UIView {
    @IBOutlet private weak var emptyCartLabel: UILabel!
    @IBOutlet private weak var startShoppingButton: UIButton!
    
    weak var delegate: CartEmptyDataViewDelegate?
    
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
        emptyCartLabel.text = "Label.YourCartIsEmpty".localizable
        startShoppingButton.setTitle("Button.StartShopping".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func startShoppingButtonDidPress(_ sender: UIButton) {
        delegate?.viewDidTapStartShopping(self)
    }
}
