//
//  CartEmptyDataView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/12/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol CartEmptyDataViewProtocol: class {
    func didTapStartShopping()
}

class CartEmptyDataView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emptyCartLabel: UILabel!
    @IBOutlet weak var startShoppingButton: UIButton!
    
    weak var delegate: CartEmptyDataViewProtocol?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: CartEmptyDataView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
    }
    
    private func setupViews() {
        emptyCartLabel?.text = "Label.YourCartIsEmpty".localizable
        startShoppingButton.setTitle("Button.StartShopping".localizable.uppercased(), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func startShoppingTapped(_ sender: UIButton) {
        delegate?.didTapStartShopping()
    }
}
