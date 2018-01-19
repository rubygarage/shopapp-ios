//
//  CheckoutShippingOptionsEnabledTableCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 1/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol CheckoutShippingOptionsEnabledTableCellProtocol: class {
    func didSelect(shippingRate: ShippingRate)
}

class CheckoutShippingOptionsEnabledTableCell: UITableViewCell {
    @IBOutlet private weak var selectRateButton: UIButton!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var rate: ShippingRate!
    
    weak var delegate: CheckoutShippingOptionsEnabledTableCellProtocol?
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    public func configure(with rate: ShippingRate, currencyCode: String, selected: Bool) {
        selectRateButton.isSelected = selected
        let formatter = NumberFormatter.formatter(with: currencyCode)
        let price = NSDecimalNumber(string: rate.price ?? "")
        priceLabel.text = formatter.string(from: price)
        titleLabel.text = rate.title
        self.rate = rate
    }
    
    // MARK: - Actions
    
    @IBAction func selectShippingRateTapped(_ sender: UIButton) {
        delegate?.didSelect(shippingRate: rate)
    }
}
