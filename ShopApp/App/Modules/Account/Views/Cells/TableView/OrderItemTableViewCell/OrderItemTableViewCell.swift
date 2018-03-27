//
//  OrderItemTableViewCell.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/5/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class OrderItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var quantityValueLabel: UILabel!
    
    @IBOutlet private weak var itemPriceLabel: UILabel! {
        didSet {
            itemPriceLabel.isHidden = true
        }
    }
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        setupViews()
    }
    
    // MARK: - Setup
    
    func configure(with orderItem: OrderItem, currencyCode: String) {
        itemImageView.set(image: orderItem.productVariant?.image)
        
        titleLabel.text = orderItem.title
        quantityValueLabel.text = String(orderItem.quantity!)
        
        guard let productVariant = orderItem.productVariant else {
            totalPriceLabel.text = "Label.N/A".localizable
            subtitleLabel.text = nil
            itemPriceLabel.isHidden = true
            return
        }
        
        let formatter = NumberFormatter.formatter(with: currencyCode)
        let price = NSDecimalNumber(decimal: productVariant.price ?? Decimal())
        let totalPrice = NSDecimalNumber(value: price.doubleValue * Double(orderItem.quantity!))
        
        totalPriceLabel.text = formatter.string(from: totalPrice)
        itemPriceLabel.isHidden = !(orderItem.quantity! > 1)
        
        if orderItem.quantity! > 1 {
            itemPriceLabel.text = String.localizedStringWithFormat("Label.PriceEach".localizable, formatter.string(from: price)!)
        }
        
        guard let options = productVariant.selectedOptions else {
            subtitleLabel.text = nil
            return
        }
        
        var subtitle = ""
        
        options.forEach {
            let text = String.localizedStringWithFormat("Label.Order.Option".localizable, $0.name, $0.value)
            subtitle.append(text)

            if options.last?.value != $0.value {
                subtitle.append("\n")
            }
        }
        
        subtitleLabel.text = subtitle
    }
    
    private func setupViews() {
        quantityLabel.text = "Label.Order.Quantity".localizable
    }
}
